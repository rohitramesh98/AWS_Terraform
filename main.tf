# Main  terraform configuration
# Configure the AWS Provider


# Two Virtual MAchines
# In default VPC
 resource "aws_instance" "web1"{
    ami = "ami-02b49a24cfb95941c"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "webserver"
    }
}

# In customizde VPC
 resource "aws_instance" "db"{
   ami = "ami-0522ab6e1ddcc7055"
   instance_type = "t3.micro"
   availability_zone = "ap-south-1b"
   subnet_id = aws_subnet.vpc2_subnet1.id #private IP machine
   
   tags = {
      Name = "dbserver"
   }
 }

# VPC,  1- subnet, IGW, 1- Route table, Route table association
# example: vpc.id = 1234
resource "aws_vpc" "vpc2"{
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
tags = {
  Name = "VPC2"
}
}

resource "aws_subnet" "vpc2_subnet1"{
  vpc_id     = aws_vpc.vpc2.id   # subnet is dependent on vpc2
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "VPC2_PUBLIC_SUBNET"
  }
}

resource "aws_internet_gateway" "vpc2_igw"{
  vpc_id = aws_vpc.vpc2.id
  
  tags = {
    Name = "VPC2_IGW"
  }
}

resource "aws_route_table" "vpc2_rt"{
vpc_id = aws_vpc.vpc2.id

route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vpc2_igw.id
}

tags = {
  Name = "VPC2_ROUTETABLE"
}
}

# route table association
resource "aws_route_table_association" "vpc2_rt_subnet1" {
  subnet_id      = aws_subnet.vpc2_subnet1.id
  route_table_id = aws_route_table.vpc2_rt.id
}

