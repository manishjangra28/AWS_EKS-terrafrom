provider "aws" {
  region = var.location
}

// Create VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "EKS-VPC"
  }
}

// Create Subnet
resource "aws_subnet" "demo_subnet-1" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.subnet1-cidr
  availability_zone = var.subnet_az-1

  tags = {
    Name = "demo_subnet-1"
  }
}

resource "aws_subnet" "demo_subnet-2" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.subnet2-cidr
  availability_zone = var.subnet_az-2

  tags = {
    Name = "demo_subnet-2"
  }
}
// Create Internet Gateway

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags = {
    Name = "demo-rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "demo-rt_association-1" {
  subnet_id = aws_subnet.demo_subnet-1.id

  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_route_table_association" "demo-rt_association-2" {
  subnet_id = aws_subnet.demo_subnet-2.id

  route_table_id = aws_route_table.demo-rt.id
}
// create a security group 

resource "aws_security_group" "demo-vpc-sg" {
  name = "demo-vpc-sg"

  vpc_id = aws_vpc.eks-vpc.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


module "security_group" {
  source = "./sg_eks"
  vpc_id = aws_vpc.eks-vpc.id
}

module "eks_cluster" {
  source = "./eks"
  vpc_id = aws_vpc.eks-vpc.id
  sg_ids = module.security_group.security_group_public
  subnet_ids = [ aws_subnet.demo_subnet-1.id, aws_subnet.demo_subnet-2.id ]
}