variable "vpc-id" {
  type = string
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
variable "cidr" {
  type = string
}