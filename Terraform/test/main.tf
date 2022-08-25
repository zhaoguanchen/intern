provider "aws" {
  region = "us-east-2"
  #   add aws access key and secret key if you haven't set up aws on your computer
  access_key = ""
  secret_key = ""
}


resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  vpc      = true
}

#print the public ip address
output "ip_public" {
  value = aws_eip.lb.public_ip
}

 

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

 


##
# Public Security Group
##
 
resource "aws_security_group" "public" {
  name = "public"
  description = "Public internet access"
  # vpc_id = aws_vpc.main.id
 
  tags = {
    Name        = "public"
    Role        = "public"
    Project     = "cloudcasts.io"
    Environment = "var.infra_env"
    ManagedBy   = "terraform"
  }
}
 
resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.public.id
}
 
resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
 
resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 6080
  to_port           = 6080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
 
resource "aws_security_group_rule" "public_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
 



# instance
resource "aws_instance" "web" {
  # find the ami from was EC2 dashboard 
  ami           = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  # name of the private key file
  key_name = "cc"
  # security group name
  vpc_security_group_ids = [aws_security_group.public.id] 
  # command that would be executed
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo docker pull biodepot/bwb:latest
                sudo docker run --rm -p 6080:6080 -v $(pwd):/data -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/.X11-unix:/tmp/.X11-unix  --privileged --group-add root biodepot/bwb
                EOF
  tags = {
    # instance name
    Name = "bwb"
  }
}