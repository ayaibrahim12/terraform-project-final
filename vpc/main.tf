#--------------------------"vpc"--------------------------------
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc-cidr
    tags = {
        "Name" = var.vpc-name
    }
}