variable "vpc-name" {
  type        = string
  description = "this is the name of vpc"
  default = "iti-vpc"
}

variable "vpc-cidr" {
  type        = string
  description = "this is the cidr of vpc"
  default = "10.0.0.0/16"
}