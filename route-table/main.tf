#--------------------------"route tables"--------------------------------
resource "aws_route_table" "route-table" {
    vpc_id = var.vpc-id
    route {
        cidr_block  = var.cidr
        gateway_id = var.internet-gateway-id
    }
    tags = {
        Name = var.route-table-name
    }
}
