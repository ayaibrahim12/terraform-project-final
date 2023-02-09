resource "aws_subnet" "subnets" {
    vpc_id = var.vpc-id
    for_each = var.subnets-cidr
    cidr_block = each.key
    availability_zone = each.value
    tags = {
        Name = var.subnet-name
    }
}