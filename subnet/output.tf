output "subnets-id" {
    value = values(aws_subnet.subnets)[*].id
}
# output "subnet2-id" {
#     value = aws_subnet.subnets["10.0.1.0/24"].id
# }
# output "subnet3-id" {
#     value = aws_subnet.subnets["10.0.2.0/24"].id
# }
# output "subnet4-id" {
#     value = aws_subnet.subnets["10.0.3.0/24"].id
# }