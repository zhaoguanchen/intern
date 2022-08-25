provider "aws" {
  region = "us-east-2"
  #   add aws access key and secret key if you haven't set up aws on your computer
  access_key = "AKIA5H743SWLHNKRMRQ5"
  secret_key = "yIgAMmNqfP0/dBZg4PV+uUhjCbtGdY6l2ErkAWHc"
}


# instance
resource "aws_instance" "web" {
  # find the ami from was EC2 dashboard 
  ami                    = "ami-02f3416038bdb17fb"
  instance_type          = "t2.micro"
  # name of the private key file
  key_name               = "cc"
  # security group name
  vpc_security_group_ids = ["gczhao"]
  # command that would be executed
  user_data              = <<-EOF
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

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  vpc      = true
}

#print the public ip address
output "ip_public" {
  value = aws_eip.lb.public_ip
}