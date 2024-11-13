module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.26.0"  # Use the latest version
  cluster_name    = "my-eks-cluster"
  cluster_endpoint_public_access = true
  attach_cluster_encryption_policy = false
  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
  enable_cluster_creator_admin_permissions = true

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    my-node-group = {
      min_size     = 3
      max_size     = 5  # Keep the max size low for cost savings
      desired_size = 3

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"  # Use SPOT instances for further savings
    }
  }

  tags = local.tags
  depends_on=[module.vpc]
}

