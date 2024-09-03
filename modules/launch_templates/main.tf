module "sg"{
 source= "./../sg"
}


resource "aws_launch_template" "ec2_template" {
  name          = "eks-node-instance"
  image_id      = "ami-0fa1ca9559f1892ec"
  instance_type = "t2.micro"

  key_name = null



  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eks-node-instanc"
    }
  }


  network_interfaces {
    security_groups = [module.sg.sg_id]
  }
}
output "launch_template_id" {
  value = aws_launch_template.ec2_template.id
}
