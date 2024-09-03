module "variable_account"{
 source= "./../../variables"
}
locals {
    s3_name = "bucket-${module.variable_account.account_id}"
}
module "codebuild_role"{
  source= "./../iam_roles/aws-codepipeline-lab-codebuild-role"
}
resource "aws_codebuild_project" "aws-codepipeline-lab-codebuild-project" {
  name          = "aws-codepipeline-lab-codebuild-project"
  description   = ""
  build_timeout = 100
  service_role  = module.codebuild_role.codebuild_role_arn

  artifacts {
    type = "S3"
    name = local.s3_name
    location=local.s3_name
  }


  source {
    type            = "GITHUB"
    location        = "https://github.com/theHaziqali/aws-codepipeline-lab-repo/tree/eks-web-app"
    git_clone_depth = 1
      buildspec       = "buildspec.yml"
  }

  source_version = "master"
    environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
       
        environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }
    environment_variable {  
      name  = "AWS_ACCOUNT_ID"
      value = module.variable_account.account_id
    }
        environment_variable {  
      name  = "IMAGE_REPO_NAME"
      value = "ecr_repo"
    }
           environment_variable {  
      name  = "IMAGE_TAG"
      value = "latest"
    }
    privileged_mode = true



  }

  cache {
    type = "NO_CACHE"
  }

}