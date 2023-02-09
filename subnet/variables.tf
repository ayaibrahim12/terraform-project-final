variable "vpc-id" {
  type = string
}

variable "subnets-cidr" {
  type        = map
  description = "those are subnets cidr "
  default = {
  "us-east-1a" = "10.0.0.0/24"
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
  "us-east-1b" = "10.0.3.0/24"
  }
}

variable "subnet-name" {
  type = string
}
