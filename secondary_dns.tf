resource "aws_security_group" "secondary_dns_security" {
  name = "secondary-dns-security"
  vpc_id = aws_vpc.clcom-vpc.id

  tags = {
    Name = "secondary-dns-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sdns_allow_ssh" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "sdns_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "secondary_dns" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  private_ip = "10.0.0.253"
  vpc_security_group_ids = [aws_security_group.secondary_dns_security.id]
  subnet_id = aws_subnet.clcom-subnet.id

  key_name = aws_key_pair.labuser.key_name

  tags = {
    Name = "secondary-dns"
  }
}
