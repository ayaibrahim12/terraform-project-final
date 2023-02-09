
variable "load-balancer-name" {
  type = string
}
variable "load-balancer-SG" {
  type = string
}
variable "load-balancer-internal-choise" {
  type = string
}

variable "load-balancer-type" {
  type = string
}

variable "load-balancer-subnets-ids" {
  type = list
}

variable "target_group_name" {
  type = string
}

variable "vpc-id" {
  type = string
}

variable "target_group_type" {
  type = string
}
variable "instance_ids" {
  type = map
}
