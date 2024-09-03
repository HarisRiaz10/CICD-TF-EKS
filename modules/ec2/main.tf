module "sg"{
 source= "./../sg"
}
module "aws-codepipeline-lab-instance-role"{
    source= "./../iam_roles/aws-codepipeline-lab-instance-role"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "codepipeline_lab_instance_profile" {
  name = "codepipeline-lab-instance-profile"

  role = module.aws-codepipeline-lab-instance-role.lab_instance_role_name
}

resource "aws_instance" "my_app"{
    ami= "ami-0fa1ca9559f1892ec"
    instance_type= "t2.micro"

    key_name= null
    security_groups  = [module.sg.sg_name]
  iam_instance_profile = aws_iam_instance_profile.codepipeline_lab_instance_profile.name

    user_data=<<-EOF
    #!/bin/bash

# Enabling admin rights
sudo su

# send script output to /tmp so we can debug boot failures
exec > /tmp/userdata.log 2>&1 

# Update all packages
yum -y update
yum -y install ruby
yum -y install wget

# Installing the CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
cd /../..

# Downloading and Installing NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Adding the nvm environmental variable to path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Installing Node
nvm install 16

# Re-adding the nvm environmental variable for the ec2-user account
cat <<EOF >> /home/ec2-user/.bashrc
export NVM_DIR="/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF


    tags={
        Name="aws-codepipeline-lab-instance"
    }


}
output "public_ip" {
  value = aws_instance.my_app.public_ip
}