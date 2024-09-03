module "codedeploy"{
    source="./../iam_roles/aws-codepipeline-lab-codedeploy-role"
}


resource "aws_codedeploy_app" "aws-codepipeline-lab-application" {
  name = "aws-codepipeline-lab-application"

}


resource "aws_codedeploy_deployment_group" "staging" {
  app_name              = aws_codedeploy_app.aws-codepipeline-lab-application.name
  deployment_group_name = "staging"
  service_role_arn      = module.codedeploy.codedeploy_role_arn
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "aws-codepipeline-lab-instance"
    }

  }

}