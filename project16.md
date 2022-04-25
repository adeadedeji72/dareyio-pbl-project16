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
resource "aws_vpc" "main" {
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
