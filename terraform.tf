provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "project-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "project-gw" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "gateway"
  }
}

resource "aws_route_table" "project-rt" {
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.project-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.project-gw.id
  }


 tags= {
    Name = "route table"
  }
}
resource "aws_subnet" "project-sb" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}


resource "aws_route_table_association" "a" {
  route_table_id = aws_route_table.project-rt.id
  subnet_id         = aws_subnet.project-sb.id
 

}
resource "aws_security_group" "project-sg" {
  name        = "project-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.project-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }




  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "security groups"
  }
}

resource "aws_instance" "ec2-instance-1" {
ami = "ami-053b0d53c279acc90"
instance_type = "t2.micro"
availability_zone = "us-east-1a"
key_name = "devtest"
vpc_security_group_ids = ["sg-0a8c5ae13c56f43da"]
tags = {
  Name = "ec2-test-server"
}
}
resource "aws_instance" "ec2-instance-2" {
ami = "ami-053b0d53c279acc90"
instance_type = "t2.micro"
availability_zone = "us-east-1a"
key_name = "devtest"
vpc_security_group_ids = ["sg-0a8c5ae13c56f43da"]
tags = {
  Name = "ec2-prod-server"
}
}


