module "variable_account"{
 source= "./../../../variables"
}
resource "aws_iam_role" "aws-codepipeline-lab-codebuild-role" {
  name = "aws-codepipeline-lab-codebuild-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com" # Update with the appropriate service principal if needed
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AWSCodeBuildRole" {
  policy_arn = "arn:aws:iam::${module.variable_account.account_id}:policy/AWSCodeBuild"  # Replace 'XYZ' with the actual policy name or ARN

  role = aws_iam_role.aws-codepipeline-lab-codebuild-role.name
}
output "codebuild_role_arn"{
  value=aws_iam_role.aws-codepipeline-lab-codebuild-role.arn
}