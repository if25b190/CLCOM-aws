resource "aws_security_group" "primary_dns_security" {
  name = "primary-dns-security"
  vpc_id = aws_vpc.clcom-vpc.id

  tags = {
    Name = "primary-dns-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "pdns_allow_tls_ipv6" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "primary_dns" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  private_ip = "10.0.0.254"
  vpc_security_group_ids = [aws_security_group.primary_dns_security.id]
  subnet_id = aws_subnet.clcom-subnet.id

  tags = {
    Name = "primary-dns"
  }
}
