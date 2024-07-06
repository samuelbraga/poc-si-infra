variable "context" {
  default = ""
  type = string
}

variable "environment" {
  default = ""
  type = string
}

variable "vpc_id" {
  default = ""
  type = string
}

variable "subnets" {
  default = [""]
  type = list(string)
}

variable "cluster_version" {
  default = ""
  type = string
}
