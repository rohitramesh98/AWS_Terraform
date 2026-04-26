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
   associate_public_ip_address = true
   tags = {
      Name = "dbserver"
   }
 }