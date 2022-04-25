# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM PART 1 #

![](tooling_project_16.png)

We will use Infrastructure Automation tool to implement IAC (Infrastructure as a Code) the network infrastructure above.

Prerequisites for this Project
1. Ensure you have at least Python3.6 installed 
1. Create an IAM account from your main account with **AdministratorAccess** permission
1. Create an s3 bucket
1. Configure programmatic access from your workstation to connect to AWS using the access keys copied above and a Python SDK (boto3).

Install Python with:
~~~
sudo apt install python3
~~~
Install botox3
~~~
 sudo python -m venv .venv
...
sudo . .venv/bin/activate

sudo python -m pip install boto3
~~~

Test the Programatic account you created 
~~~
import boto3
s3 = boto3.resource('s3')
for bucket in s3.buckets.all():
    print(bucket.name)
~~~
The above should display the name of your s3 bucket

Create a folder called PBL
Create a file in the folder, name it main.tf
~~~
sudo mkdir PBL
sudo touch PBL/main.tf
~~~
### Provider and VPC resource section ###
- Add AWS as a provider, and a resource to create a VPC in the main.tf file.
- Provider block informs Terraform that we intend to build infrastructure within AWS.
- Resource block will create a VPC

~~~
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "PRJ16-vpc" {
  cidr_block                     = "172.16.0.0/16"
  enable_dns_support             = "true"
  enable_dns_hostnames           = "true"
  enable_classiclink             = "false"
  enable_classiclink_dns_support = "false"
}
~~~

### Propare your PBL folder for Terraform
~~~
sudo terraform init
~~~
This downloads all required terraform plugins for the selected provider (aws in this case) and provisioner

![](terraform-init.jpg)

Then run
~~~
sudo terraform plan
~~~
This will displan what the main.tf file will produce as output in our specified region

If satisfied with the output, run
~~~
sudo terraform apply
~~~
to build the infrastructure described in the main.tf file

### Let us create the first 2 public subnets. ###
Add below to the main.tf file

~~~
# Create public subnets1
    resource "aws_subnet" "public1" {
    vpc_id                     = aws_vpc.PRJ16-vpc.id
    cidr_block                 = "172.16.0.0/24"
    map_public_ip_on_launch    = true
    availability_zone          = "us-east-1a"

}

# Create public subnet2
    resource "aws_subnet" "public2" {
    vpc_id                     = aws_vpc.PRJ16-vpc.id
    cidr_block                 = "172.16.1.0/24"
    map_public_ip_on_launch    = true
    availability_zone          = "us-east-1b"
}
~~~
The *vpc_id* tells Terraform which VPC to create the subnets

Then run terraform plan and terraform apply 
~~~
sudo terraform plan
~~~
When satisfied 
~~~
sudo terraform apply
~~~

Go to your AWS console to varify the result
![](terraform-pub-subnets.jpg)

So values were hard-coded, this will present problems moving forward, let is refactor the codes

### FIXING THE PROBLEMS BY CODE REFACTORING ###

Let us declare these variable as used in our IaC

~~~
 variable "region" {
        default = "us-east-1"
 }

 }
 variable "region" {
        default = "us-east-1"
}
variable "vpc_cidr" {
        default = "172.16.0.0/16"
}

variable "enable_dns_support" {
        default = "true"
}

variable "enable_dns_hostnames" {
        default ="true" 
}

variable "enable_classiclink" {
        default = "false"
}

variable "enable_classiclink_dns_support" {
        default = "false"
}

provider "aws" {
    region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
    cidr_block                     = var.vpc_cidr
    enable_dns_support             = var.enable_dns_support 
    enable_dns_hostnames           = var.enable_dns_support
    enable_classiclink             = var.enable_classiclink
    enable_classiclink_dns_support = var.enable_classiclink
~~~
Terraform uses **Data Source** to pull data from providers, here we will use data source to pull a list of availability zones from a specific AWS region

~~~
  # Get list of availability zones
data "aws_availability_zones" "available" {
state = "available"
}
~~~
