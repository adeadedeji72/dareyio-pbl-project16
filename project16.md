# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM PART 1 #

![](tooling_project_16.png)

We will use Infrastructure Automation tool to implement IAC (Infrastructure as a Code) the network infrastructure above.

Prerequisites for this Project
1. Ensure you have at least Python3.6 installed 
1. Create an IAM account from your main account with **AdministratorAccess** permission
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
