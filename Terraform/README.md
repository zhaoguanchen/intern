# terraform
 terraform script and toturials



# 1. Commands

**Format and validate the configuration**

```bash
terraform fmt
```

```bash
terraform validate
```

**Initializes**

Initializes the environment and pulls down the AWS provider.

```bash
terraform init
```

**Plan**

 Creates an execution plan for the environment and confirms no bugs are found.

```bash
terraform plan
```

**Create**

```bash
terraform apply
```

```bash
# always yes
terraform apply --auto-approve
```

**Destroy**

```bash
terraform destroy --auto-approve
```





# Reference

1. [Terraform Doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
2. [https://cloudcasts.io/course/terraform](https://cloudcasts.io/course/terraform)
3. [How to launch an EC2 instance using Terraform](https://www.techtarget.com/searchcloudcomputing/tip/How-to-launch-an-EC2-instance-using-Terraform)
4. [Learn Terraform by Deploying a Jenkins Server on AWS](https://www.freecodecamp.org/news/learn-terraform-by-deploying-jenkins-server-on-aws/#how-to-work-with-terraform-modules)
