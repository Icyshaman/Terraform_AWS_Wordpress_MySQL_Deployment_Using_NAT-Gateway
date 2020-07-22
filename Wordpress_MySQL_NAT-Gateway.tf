provider "aws"{
	region	= "ap-south-1"
	profile	= "vikas"
}

# Creates a VPC
resource "aws_vpc" "vpc1"{
	cidr_block		= "10.0.0.0/16"
	instance_tenancy	= "default"
	
	tags = {
		Name	= "vpc1"
	}
}

# Creates Subnet
resource "aws_subnet" "public_subnet"{
	vpc_id			= aws_vpc.vpc1.id
	cidr_block		= "10.0.0.0/24"
	availability_zone 	= "ap-south-1a"

	tags = {
		Name	= "public_subnet"	
	}
}

resource "aws_subnet" "private_subnet"{
	vpc_id			= aws_vpc.vpc1.id
	cidr_block		= "10.0.1.0/24"
	availability_zone 	= "ap-south-1b"

	tags = {
		Name	= "private_subnet"
	}
}

# Creates Security Group
resource "aws_security_group" "public_security_group"{
	name		= "public_security_group"
	description 	= "Allow SSH and HTTP inbound traffic"
	vpc_id		= aws_vpc.vpc1.id

	ingress{
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
  
	ingress{
    		from_port   = 80
    		to_port     = 80
    		protocol    = "tcp"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	egress{
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks =  ["0.0.0.0/0"]
  	}
  

  	tags = {
    		Name	= "public_security_group"
  	}
}

resource "aws_security_group" "private_security_group"{
	name		= "private_security_group"
	description 	= "Allow SSH and MYSQL inbound traffic"
	vpc_id		= aws_vpc.vpc1.id
	
	ingress{
		from_port   	= 22
		to_port		= 22
		protocol    	= "tcp"
		security_groups	= [aws_security_group.public_security_group.id]
	}
	
	ingress{
		from_port   	= 3306
		to_port		= 3306
		protocol    	= "tcp"
		security_groups	= [aws_security_group.public_security_group.id]
	}

	egress{
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks =  ["0.0.0.0/0"]
  	}

  	tags = {
    		Name	= "private_security_group"
  	}
}

# Creates Internet Gateway
resource "aws_internet_gateway" "igw1"{
  	vpc_id	= aws_vpc.vpc1.id

  	tags = {
    		Name	= "igw1"
  	}
}

# Creates Routing Table
resource "aws_route_table" "route_table1"{
	vpc_id	= aws_vpc.vpc1.id

	route{
    		cidr_block	= "0.0.0.0/0"
    		gateway_id	= aws_internet_gateway.igw1.id
  	}

  	tags = {
    		Name	= "route_table1"
  	}
}

# Associate Routing Table to Subnet
resource "aws_route_table_association" "associate_rt_to_sub"{
  	subnet_id	= aws_subnet.public_subnet.id
  	route_table_id	= aws_route_table.route_table1.id
}

# Creates Elastic IP
resource "aws_eip" "eip1"{
	vpc	= true
}

# Creates NAT Gateway
resource "aws_nat_gateway" "nat_gateway"{
  	allocation_id	= aws_eip.eip1.id
  	subnet_id	= aws_subnet.public_subnet.id

  	tags = {
    		Name	= "nat_gateway"
   	}
}

#Creates Routing Table
resource "aws_route_table" "route_table2"{
	vpc_id	= aws_vpc.vpc1.id
  
	route{
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.nat_gateway.id
   	}

     	tags = {
    		Name	= "route_table2"
  	} 
}

# Associate Routing Table to Subnet
resource "aws_route_table_association" "associate_rt_to_prv_sub"{
  	subnet_id	= aws_subnet.private_subnet.id
  	route_table_id	= aws_route_table.route_table2.id
}

# Launch Instance
resource "aws_instance" "wordpress"{
  	ami           			= "ami-000cbce3e1b899ebd"
  	instance_type 			= "t2.micro"
	key_name 			= "mykey1"
  	associate_public_ip_address	= true
  	subnet_id 			= aws_subnet.public_subnet.id
  	vpc_security_group_ids 		= [aws_security_group.public_security_group.id]

  	tags = {
    		Name	= "wordpress"
  	}
}

resource "aws_instance" "mysql"{
	ami           		= "ami-0019ac6129392a0f2"
  	instance_type		= "t2.micro"
  	key_name		= "mykey1"
  	subnet_id 		= aws_subnet.private_subnet.id
  	vpc_security_group_ids 	= [aws_security_group.private_security_group.id]

 	tags = {
    		Name 	= "mysql"
  	}
}