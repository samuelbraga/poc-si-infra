variable "aws_region" {
  default = ""
  type = string
}

variable "context" {
  default = ""
  type = string
}

variable "environment" {
  default = ""
  type = string
}

variable "vpc_cidr_block" {
  default = ""
  type = string
}

variable "public_subnets_cidr" {
  default = [""]
  type = list(string)
}

variable "private_subnets_cidr" {
  default = [""]
  type = list(string)
}

variable "cluster_name" {
  default = ""
  type = string
}
