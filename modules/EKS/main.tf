module "eks_cluster_role" {
  source = "../iam_roles/eks-cluster-role"
}
module "eks_node_role" {
  source = "../iam_roles/eks-node-role"
}
module "launch_template" {
    source = "../launch_templates"
  }
resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default" {
availability_zone = "us-east-1a"

  }
  resource "aws_default_subnet" "default_2" {
availability_zone = "us-east-1b"

  }



resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = module.eks_cluster_role.eks_cluster_role_arn

  vpc_config {
  subnet_ids      = [resource.aws_default_subnet.default.id,resource.aws_default_subnet.default_2.id]
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-eks-nodes"
  node_role_arn   = module.eks_node_role.eks_node_role_arn
  subnet_ids      = [aws_default_subnet.default.id,aws_default_subnet.default_2.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }



  depends_on = [
    aws_eks_cluster.eks_cluster
  ]

 
    tags={
        Name="eks-node-group"
    }

}
output "eks" {
  value = aws_eks_cluster.eks_cluster.arn
}
