resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet-id
  tags = {
    "name" = var.nat-gatway-name
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}