#--------------------"vpc"--------------------
module "vpc"{
    source = "./vpc"
    vpc-name = "iti-vpc"
    vpc-cidr = "10.0.0.0/16"
}
#--------------------"subnets"--------------------
module "subnets" {
  source = "./subnet"
  vpc-id = module.vpc.vpc-id
  subnets-cidr = { 
    "10.0.0.0/24" = "us-east-1a"
    "10.0.1.0/24" = "us-east-1a"
    "10.0.2.0/24" = "us-east-1b"
    "10.0.3.0/24" = "us-east-1b" 
    }
  subnet-name = "iti-subnet"
}
#-------------------"internet gateway"----------------------
module "iti-internet-gateway" {
  source = "./internet-gateway"
  vpc-id = module.vpc.vpc-id
  internet-gateway-name = "iti-internet-gateway"
}
module "public-route-table" {
  source = "./route-table"
  vpc-id = module.vpc.vpc-id
  internet-gateway-id = module.iti-internet-gateway.internet-gateway-id
  route-table-name = "public-route-table"
  cidr = "0.0.0.0/0"
  subnet-id = module.subnets.subnets-id[0]
}
module "subnet-az1-association" {
  source = "./route-table-association"
  route-table-id = module.public-route-table.route-table-id
  subnet-id = module.subnets.subnets-id[0]
}
module "subnet-az2-association" {
  source = "./route-table-association"
  route-table-id = module.public-route-table.route-table-id
  subnet-id = module.subnets.subnets-id[2]
}
#-------------------"nat-gateway"----------------------
module "iti-nat-gateway" {
  source = "./nat-gateway"
  nat-gatway-name = "iti-nat-gateway"
  subnet-id = module.subnets.subnets-id[0]
}
module "nat-route-table" {
  source = "./nat-route-table"
  vpc-id = module.vpc.vpc-id
  nat-gateway-id = module.iti-nat-gateway.nat-gateway-id
  nat-route-table-name = "iti-nat-route-table"
  cidr = "0.0.0.0/0"
}
module "nat-az1-association" {
  source = "./route-table-association"
  route-table-id = module.nat-route-table.nat-route-id
  subnet-id = module.subnets.subnets-id[1]
}
module "nat-az2-association" {
  source = "./route-table-association"
  route-table-id = module.nat-route-table.nat-route-id
  subnet-id = module.subnets.subnets-id[3]
}
#------------------"security group"-----------------
module "main-security-group" {
  source = "./security-groups"
  vpc-id = module.vpc.vpc-id
  cidr = "0.0.0.0/0"
  security_group-ports ={
    ssh = 22
    http = 80
    egress = 0
  }
  security_group-protocol = {
    "ingress" = "tcp"
    "egress" = "-1"
  }
}
#------------------"proxy ec2"---------------------
module "proxy-az1" {
  source = "./proxy-machine"
  ec2-metadata = {
    "image" = "ami-06878d265978313ca"
    "type" = "t2.micro"
    "key_pair" = "nginx"
  }
  proxy-ec2-name = "proxy-az1" 
  security_group-id = module.main-security-group.security-group-id
  subnet-id = module.subnets.subnets-id[0]
  ec2_connection_type =  "ssh"
  ec2_connection_user = "ubuntu"
  ec2_connection_private_key = "./nginx.pem"
  ec2_provisioner_file_source = "./nginx.sh"
  ec2_provisioner_file_destination = "/tmp/nginx.sh"
  ec2_provisioner_inline = [
    "chmod 777 /tmp/nginx.sh",
    "/tmp/nginx.sh ${module.iti-public-load-balancer.lb-dns}" ]
}
#---
module "proxy-az2" {
  source = "./proxy-machine"
  ec2-metadata = {
    "image" = "ami-06878d265978313ca"
    "type" = "t2.micro"
    "key_pair" = "nginx"
  }
  proxy-ec2-name = "proxy-az2" 
  security_group-id = module.main-security-group.security-group-id
  subnet-id =  module.subnets.subnets-id[2]
  ec2_connection_type =  "ssh"
  ec2_connection_user = "ubuntu"
  ec2_connection_private_key = "./nginx.pem"
  ec2_provisioner_file_source = "./nginx.sh"
  ec2_provisioner_file_destination = "/tmp/nginx.sh"
  ec2_provisioner_inline = ["chmod 777 /tmp/nginx.sh",
  "/tmp/nginx.sh ${module.iti-public-load-balancer.lb-dns}"]
}

#------------------"private machine"-------------------
module "private-az1" {
  source = "./private-machine"
  ec2-metadata = {
    "image" = "ami-06878d265978313ca"
    "type" = "t2.micro"
    "key_pair" = "nginx"
  }
  private-ec2-name = "private-az1" 
  security_group-id = module.main-security-group.security-group-id
  subnet-id =  module.subnets.subnets-id[1]
}
#---
module "private-az2" {
  source = "./private-machine"
  ec2-metadata = {
    "image" = "ami-06878d265978313ca"
    "type" = "t2.micro"
    "key_pair" = "nginx"
  }
  private-ec2-name = "private-az2" 
  security_group-id = module.main-security-group.security-group-id
  subnet-id =  module.subnets.subnets-id[3]
}
#------------------"load balancer"---------------------
module "iti-public-load-balancer" {
  source = "./load-balancer"
  vpc-id = module.vpc.vpc-id
  load-balancer-name = "iti-proxy-lb"
  load-balancer-SG = module.main-security-group.security-group-id
  load-balancer-internal-choise = false
  load-balancer-type = "application"
  load-balancer-subnets-ids = [module.subnets.subnets-id[0],module.subnets.subnets-id[2]]
  target_group_name = "proxy-target-group"
  target_group_type = "instance"
  instance_ids = {
    "machine1" = module.proxy-az1.id,
    "machine2" = module.proxy-az2.id
    }
}
#-------------------"private lb"-------------------------
module "iti-private-load-balancer" {
  source = "./load-balancer"
  vpc-id = module.vpc.vpc-id
  load-balancer-name = "iti-private-lb"
  load-balancer-SG = ""
  load-balancer-internal-choise = true
  load-balancer-type = "network"
  load-balancer-subnets-ids = [module.subnets.subnets-id[1],module.subnets.subnets-id[3]]
  target_group_name = "private-target-group"
  target_group_type = "instance"
  instance_ids = {
    "machine1" = module.private-az1.id,
    "machine2" = module.private-az2.id
    }
}