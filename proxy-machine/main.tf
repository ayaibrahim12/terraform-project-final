resource "aws_instance" "proxy-ec2" {
    ami = var.ec2-metadata["image"]
    instance_type = var.ec2-metadata["type"]
    key_name = var.ec2-metadata["key_pair"]
    subnet_id = var.subnet-id
    security_groups = [var.security_group-id]
    associate_public_ip_address = true
    tags = {
      Name = var.proxy-ec2-name
    }
    
    connection {
      type     = var.ec2_connection_type 
      user     = var.ec2_connection_user 
      private_key = file(var.ec2_connection_private_key) 
      host     = self.public_ip 
    }

    provisioner "file" {
      source      = var.ec2_provisioner_file_source 
      destination = var.ec2_provisioner_file_destination 
    }
    
    provisioner "remote-exec" {
      inline = var.ec2_provisioner_inline
    }
    
    provisioner "local-exec" {
      command = "echo Public EC2 ip: ${self.public_ip} >> ./public_ip.txt"
    }
    
}