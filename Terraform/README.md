# Terraform
 terraform script and toturials

## 1. Terraform Commands

**Format and validate the configuration**

```bash
terraform fmt
```

```bash
terraform validate
```

**init**

Initializes the environment and pulls down the AWS provider.

The `terraform init` command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration. `terraform init` will initialize various local settings and data that will be used by subsequent commands.

```bash
terraform init
```

The output would like this:

```bash
Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.27.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```



**Plan**

 Creates an execution plan for the environment and confirms no bugs are found.

`terraform plan` shows what changes Terraform will apply to our infrastructure given the current state of our infrastructure as well as the current contents of our configuration.

The `terraform plan` command won't take any action or make any changes. Terraform uses a declarative approach in which our configuration file specifies the desired end state of the infrastructure. When we run `terraform plan`, an analysis is done to determine which actions are required to achieve this state.

```bash
terraform plan
```

**Apply**

```bash
terraform apply
```

```bash
# always yes
terraform apply --auto-approve
```

The output would like this:

```bash
aws_vpc.main: Creating...
aws_security_group.public: Creating...
aws_security_group.public: Creation complete after 1s [id=sg-064d2d287e2105b5a]
aws_security_group_rule.public_in_https: Creating...
aws_security_group_rule.public_out: Creating...
aws_security_group_rule.public_in_ssh: Creating...
aws_security_group_rule.public_in_http: Creating...
aws_instance.web: Creating...
aws_security_group_rule.public_in_https: Creation complete after 1s [id=sgrule-1026665638]
aws_security_group_rule.public_out: Creation complete after 2s [id=sgrule-993889287]
aws_security_group_rule.public_in_ssh: Creation complete after 3s [id=sgrule-1714359797]
aws_security_group_rule.public_in_http: Creation complete after 3s [id=sgrule-2746624071]
aws_instance.web: Still creating... [10s elapsed]
aws_instance.web: Still creating... [20s elapsed]
aws_instance.web: Still creating... [30s elapsed]
aws_instance.web: Creation complete after 33s [id=i-08b0a22c234067547]
aws_eip.lb: Creating...
aws_eip.lb: Creation complete after 2s [id=eipalloc-0596e573086e3e0cc]
```



We can inspect the state using **terraform show**.

**Destroy**

use the destroy command to destroy the infrastructure.

```bash
terraform destroy --auto-approve
```

Just like with apply, Terraform is smart enough to determine what order things should be destroyed. In our case, we only had one resource, so there wasn't any ordering necessary. But in more complicated cases with multiple resources, Terraform will destroy in the proper order.

## 2. Configuration

Here are some keywords for the configuration.

#### provider

First, we should define the provider. Every resource type is implemented by a provider; without providers, Terraform can't manage any kind of infrastructure.

```
provider "aws" {
  region = "us-east-2"
  #   add aws access key and secret key if you haven't set up aws on your computer
  access_key = ""
  secret_key = ""
}
```



#### resource

The **resource** block defines a resource that exists within the infrastructure. A resource might be a physical component such as an EC2 instance, or it can be a logical resource such as a Heroku application.

The **resource** block has three strings before opening the block: the **resource type**, the **resource name**, and the **key_name**.

In our example, the **resource type** is "aws_instance" and the **resource name** is "terra-sample0." The prefix of the type maps to the provider. In our case "aws_instance" automatically tells Terraform that it is managed by the "aws" provider. In order to access an EC2 instance once it is created, we need to assign an AWS EC2 Key Pair at the time of instantiating the instance.

Within the resource block itself is a configuration for that resource. For our EC2 instance, we specify an AMI for Ubuntu 16.04, and request a "t2.nano" instance.



#### variable

**define**

We can create another file named `variables. tf` to define variables.

```bash
variable "region" {}
 
variable "port_max" {
  type    = number
  default = 6080
}

variable "instance_name" {
  type        = string
  default     = "default"
  description = "AWS instance name."
}
 
```



This defines three variables within our Terraform configuration. The first one has empty blocks {}. The second one sets a default. If a default value is set, the variable is optional. Otherwise, the variable is required. If we run `terraform plan` now, Terraform will prompt us for the values for unset string variables.

 If we run `terraform plan` now, Terraform will prompt us for the values for unset string variables:

```
$ terraform plan
var.access_key
  Enter a value: A...Q

var.secret_key
  Enter a value: Q...i

Refreshing Terraform state in-memory prior to plan...
...
```





To use these variables, replace the AWS provider configuration with the following:

```
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
```





**Assign**

There are multiple ways to assign variables. 

- command-line

We can set variables directly on the command-line with the **-var** flag.

```
$ terraform plan \
  -var 'access_key=foo' \
  -var 'secret_key=bar' 
```





#### output

We can use output variables as a way to organize data to be easily queried and shown back to the Terraform user.

Outputs are a way to tell Terraform what data is important. This data is outputted when applicable and can be queried using the **terraform output** command.

Here is an example that defines an output to show us the public IP address of the elastic IP address that we create.

```bash
#print the public ip address
output "ip_public" {
  value = aws_eip.lb.public_ip
}
```

 we should see this after running `terraform apply`:

```bash
Outputs:

ip_public = "3.141.241.175"
```



#### user_data

**inserted**

Paste the script to the resource specification and use the format shown in the example. `<< EOF` and `EOF` frame the script within the `user_data` argument.

Here is a sample of using **user_data** embedded into the tf file:

```shell
##
# instance
##
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
```







**User data located in another file**

But we prefer to use a file() function:

```bash

resource "aws_instance" "web" {
  # find the ami from was EC2 dashboard 
  ami           = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  # name of the private key file
  key_name = "cc"
  # security group name
  vpc_security_group_ids = [aws_security_group.public.id] 
  # command that would be executed
  user_data = "${file("user-data.sh")}"
  tags = {
    # instance name
    Name = "bwb"
  }
}
```



The **user-data.sh** looks like this:

```bash
 #!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo docker pull biodepot/bwb:latest
sudo docker run --rm -p 6080:6080 -v $(pwd):/data -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/.X11-unix:/tmp/.X11-unix  --privileged --group-add root biodepot/bwb
```

For more about the aws_instance resource, please check [user data ](https://registry.terraform.io/providers/serverscom/serverscom/latest/docs/guides/user-data).



## 3. Usage - aws

**main.tf**

```
##
# Elastic Ip
##
resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  vpc      = true
}

##
# VPC
##
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


##
# Public Security Group
##
resource "aws_security_group" "public" {
  name        = var.instance_name
  description = "Public Security Group"
  # vpc_id = aws_vpc.main.id

  tags = {
    Name        = "public"
    Role        = "public"
    Project     = "bwb"
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


resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = var.port_min
  to_port           = var.port_max
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

resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}


##
# instance
##
resource "aws_instance" "web" {
  # find the ami from was EC2 dashboard
  ami                    = var.image
  instance_type          = var.instance_profile
  # name of the private key file
  key_name               = var.ssh_key
  # security group name
  vpc_security_group_ids = [aws_security_group.public.id]
  # command that would be executed
  user_data              = "${file(var.user_data)}"

  tags = {
    # instance name
    Name = var.instance_name
  }
}
```

**provider.tf**

```
# Configure the AWS Provider
provider "aws" {
  region     = var.region
  # add aws access key and secret key if you haven't set up aws on your computer
  access_key = var.access_key
  secret_key = var.secret_key
}
```

**variables.tf**

```
variable "access_key" {
  type        = string
  description = "AWS access key."
}

variable "secret_key" {
  type        = string
  description = "AWS secret key."
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "zone" {
  type    = string
  default = "us-east-2a"
}

variable "IPv4_subnet" {
  type    = string
  default = "10.240.0.0/24"
}

variable "port_max" {
  type    = number
  default = 6080
}

variable "port_min" {
  type    = number
  default = 6080
}


variable "ssh_key" {
  type        = string
  description = "AWS SSH pem file name."
}

variable "image" {
  type        = string
  default     = "ami-02f3416038bdb17fb"
  description = "AWS instance image ami"
}

variable "instance_name" {
  type        = string
  default     = "default"
  description = "AWS instance name."
}

variable "instance_profile" {
  type        = string
  default     = "t2.micro"
  description = "AWS instance type."
}

variable "user_data" {
  type        = string
  default     = "ls"
  description = "The bash commands that would be executed after creating the instance."
}
```

**outputs.tf**

```
#print the public ip address
output "ip_public" {
  value = aws_eip.lb.public_ip
}
```

**versions.tf**

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.30.0"
    }
  }
}
```
