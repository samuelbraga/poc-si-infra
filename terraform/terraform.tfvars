aws_region  = "sa-east-1"

context     = "poc"
environment = "dev"

vpc_cidr_block       = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets_cidr = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

cluster_version = "1.29"

istio_version = "1.22.0"
