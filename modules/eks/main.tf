locals {
  cluster_name = "${var.context}-${var.environment}"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  subnet_ids      = var.subnets
  vpc_id          = var.vpc_id
  
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    cluster_node = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true
}