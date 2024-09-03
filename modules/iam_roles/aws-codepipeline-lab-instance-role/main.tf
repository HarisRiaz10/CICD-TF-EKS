
resource "aws_iam_role" "aws-codepipeline-lab-instance-role" {
  name = "aws-codepipeline-lab-instance-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"  # Update with the appropriate service principal if needed
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforAWSCodeDeploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"  # Replace 'XYZ' with the actual policy name or ARN

  role = aws_iam_role.aws-codepipeline-lab-instance-role.name
}
output "lab_instance_role_name" {
  value=aws_iam_role.aws-codepipeline-lab-instance-role.name
}