resource "aws_security_group" "my_instance_sg" {
  name        = "my_instance_sg"
  description = "Allow incoming traffic on port 3000"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any source IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination IP
  }
  tags = {
    Name = "aws-codepipeline-lab-sg"
  }
}
output "sg_id" {
  value = aws_security_group.my_instance_sg.id
}
