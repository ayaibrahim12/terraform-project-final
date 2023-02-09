# these are global variables 

variable "ec2-metadata" {
  type        = map(string)
  description = "The id of the machine image (AMI) to use for the server."
  default = {
    "image" = "ami-06878d265978313ca"
    "type" = "t2.micro"
    "key_pair" = "nginx"
  }
}
variable "provider-aws-region" {
  type        = string
  description = "this is the aws provider region"
  default = "us-east-1"
}
variable "iti-vpc-cidr" {
  type        = string
  description = "this is the cidr of vpc"
  default = "10.0.0.0/16"
}
variable "iti-subnets-cidr" {
  type        = map
  description = "those are subnets cidr "
  default = {
  "cidr1" = "10.0.0.0/24"
  "cidr2" = "10.0.1.0/24"
  "cidr3" = "10.0.2.0/24"
  "cidr4" = "10.0.3.0/24"
  
  }
}
variable "inbound-role-anywhere_ip" {
  type        = string
  description = "this inbound role for any ip"
  default = "0.0.0.0/0"
}

variable "availability_zone" {
  type        = string
  description = "availability_zone that is work in"
  default = "us-east-1a"
}
variable "security_group-ports"{
  type        = map
  description = "the ports of security group"
  default = {
        ssh = 22
        http = 80
        egress = 0

  }
}
variable "security_group-protocol"{
  type        = map(string)
  description = "the protocols of security group"
  default = {
        "ingress" = "tcp"
        "egress" = "-1"

  }
}