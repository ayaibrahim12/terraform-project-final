resource "aws_instance" "private-ec2" {
    ami = var.ec2-metadata["image"]
    instance_type = var.ec2-metadata["type"]
    key_name = var.ec2-metadata["key_pair"]
    subnet_id = var.subnet-id
    security_groups = [var.security_group-id]
    tags = {
      Name = var.private-ec2-name
    }
    user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install nginx -y
        sudo systemctl enable --now nginx
      EOF
}

