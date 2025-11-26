provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
  token = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "clcom-vpc" {
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "clcom-vpc"
  }
}

resource "aws_subnet" "clcom-subnet" {
  vpc_id = aws_vpc.clcom-vpc.id
  cidr_block = "10.0.0.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "clcom-subnet"
  }
}

resource "aws_internet_gateway" "clcom-igw" {
  vpc_id = aws_vpc.clcom-vpc.id
}

resource "aws_route_table" "clcom-route" {
  vpc_id = aws_vpc.clcom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.clcom-igw.id
  }

  tags = {
    Name = "clcom-route" 
  }
}
