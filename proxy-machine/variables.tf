variable "ec2-metadata" {
  type        = map(string)
  description = "The id of the machine image (AMI) to use for the server."
  default = {
    "image" = "ami-06878d265978313ca"
    "type" = "t2.micro"
    "key_pair" = "nginx"
  }
}

variable "proxy-ec2-name" {
  type = string
}

variable "security_group-id"{
  type = string
}

variable "subnet-id" {
  type = string
}
variable "ec2_connection_type" {
  
}
variable "ec2_connection_user" {
  
}
variable "ec2_connection_private_key" {
  
}
variable "ec2_provisioner_file_source" {
  
}
variable "ec2_provisioner_file_destination" {
  
}
variable "ec2_provisioner_inline" {
  
}