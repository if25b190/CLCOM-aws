provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
  token = ""
}

resource "aws_key_pair" "labuser" {
  key_name = "ssh-labuser-key"
  public_key = "" // extract public key with "ssh-keygen -f labsuser.pem -y >> public_key.txt"
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

resource "aws_route_table_association" "subnet_public_igw" {
  subnet_id = aws_subnet.clcom-subnet.id
  route_table_id = aws_route_table.clcom-route.id
}

resource "aws_eip" "elastic_ip_gitlab" {
  instance = aws_instance.gitlab_server.id
  domain   = "vpc"
}
