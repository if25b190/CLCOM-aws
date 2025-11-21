provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "gitlab_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "gitlab-server"
  }
}

resource "aws_instance" "gitlab_runner" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "gitlab-runner"
  }
}

resource "aws_instance" "ldap_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "ldap-server"
  }
}

resource "aws_instance" "primary_dns" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "primary-dns"
  }
}

resource "aws_instance" "secondary_dns" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "secondary-dns"
  }
}
