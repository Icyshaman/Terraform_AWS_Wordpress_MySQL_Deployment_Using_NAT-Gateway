# Terraform_AWS_Wordpress_MySQL_Deployment_Using_NAT-Gateway
>**Overview**
* [Wordpress_MySQL_NAT-Gateway.tf](https://github.com/Icyshaman/Terraform_AWS_Wordpress_MySQL_Deployment_Using_NAT-Gateway/blob/master/Wordpress_MySQL_NAT-Gateway.tf) is a terraform file which will perform following task:
    
    * Creates a VPC.
    
    * Creates two subnets (a public and a private subnet) under created VPC.

    * Creates a public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC.

    * Creates a routing table for Internet gateway so that instance can connect to outside world, update and associate it with public subnet.

    * Creates a NAT gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC in the public network.

    * Update the routing table of the private subnet, so that to access the internet it uses the nat gateway created in the public subnet.

    * Launch an ec2 instance which has Wordpress setup already with security group allowing port 80 so that our client can connect to our wordpress site. Also attach the key to instance for further login into it.

    * Launch an ec2 instance which has MYSQL setup already with security group allowing port 3306 in private subnet so that our Wordpress instance can connect with the same. Also attach the key to instance for further login into it.
***
>**Steps to use**
* Copy [Wordpress_MySQL_NAT-Gateway.tf](https://github.com/Icyshaman/Terraform_AWS_Wordpress_MySQL_Deployment_Using_NAT-Gateway/blob/master/Wordpress_MySQL_NAT-Gateway.tf) to your local system.

* Using Command Prompt navigate to the folder where [Wordpress_MySQL_NAT-Gateway.tf](https://github.com/Icyshaman/Terraform_AWS_Wordpress_MySQL_Deployment_Using_NAT-Gateway/blob/master/Wordpress_MySQL_NAT-Gateway.tf) is stored.

* Run command **aws configure --profile < profile_name >**. (Requires AWS CLI to be installed and path need to be set)

* Enter AWS Access Key ID, AWS Secret Access Key, Default region name, Default output format.

* Run command **terraform init** to download all the plugins required.

* Run command **terraform apply** to create the infrastructure.

* Run command **terraform destroy** to destroy the infrastructure.
***
