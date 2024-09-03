
resource "aws_iam_role" "aws-codepipeline-lab-codedeploy-role" {
  name = "aws-codepipeline-lab-codedeploy-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service =  "codedeploy.amazonaws.com" # Update with the appropriate service principal if needed
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"  # Replace 'XYZ' with the actual policy name or ARN

  role = aws_iam_role.aws-codepipeline-lab-codedeploy-role .name
}
output "codedeploy_role_arn" {
  value=aws_iam_role.aws-codepipeline-lab-codedeploy-role.arn
}
