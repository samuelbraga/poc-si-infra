module "vpc" {
    source   = "./modules/vpc"

    aws_region = var.aws_region
    
    context     = var.context
    environment = var.environment

    vpc_cidr_block       = var.vpc_cidr_block
    public_subnets_cidr  = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr

    cluster_name = "${var.context}-${var.environment}"
}

module "eks" {
    source   = "./modules/eks"

    context         = var.context
    environment     = var.environment
    cluster_version = var.cluster_version
    
    vpc_id  = module.vpc.vpc_id
    subnets = module.vpc.private_subnets
}
