#--------------------------"nat route tables"--------------------------------
resource "aws_route_table" "nat-route_table" {
  vpc_id = var.vpc-id
  route {
    cidr_block = var.cidr
    nat_gateway_id = var.nat-gateway-id
  }
  tags = {
        Name = var.nat-route-table-name
    }
}