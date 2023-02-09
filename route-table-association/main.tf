#--------------------------"route tables association"--------------------------------
resource "aws_route_table_association" "subnet-association" {
    subnet_id = var.subnet-id
    route_table_id = var.route-table-id
}