resource "aws_security_group" "primary_dns_security" {
  name = "primary-dns-security"
  vpc_id = aws_vpc.clcom-vpc.id

  tags = {
    Name = "primary-dns-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "pdns_allow_ssh" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "pdns_allow_dns" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "10.0.0.28/30"
  from_port = 53
  ip_protocol = "tcp"
  to_port = 53
}

resource "aws_vpc_security_group_ingress_rule" "pdns_allow_dns_udp" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "10.0.0.28/30"
  from_port = 53
  ip_protocol = "udp"
  to_port = 53
}

// INTERNAL
resource "aws_vpc_security_group_ingress_rule" "pdns_allow_dns_internal" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "10.0.0.253/32"
  from_port = 53
  ip_protocol = "tcp"
  to_port = 53
}
resource "aws_vpc_security_group_ingress_rule" "pdns_allow_dns_udp_internal" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "10.0.0.253/32"
  from_port = 53
  ip_protocol = "udp"
  to_port = 53
}
// INTERNAL

resource "aws_vpc_security_group_ingress_rule" "pdns_allow_dns_tls" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "10.0.0.28/30"
  from_port = 853
  ip_protocol = "tcp"
  to_port = 853
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_ssh_out" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_http_out" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_https_out" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_dns_out" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 53
  ip_protocol = "tcp"
  to_port = 53
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_dns_udp_out" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 53
  ip_protocol = "udp"
  to_port = 53
}

resource "aws_vpc_security_group_egress_rule" "pdns_allow_dns_tls_out" {
  security_group_id = aws_security_group.primary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 853
  ip_protocol = "tcp"
  to_port = 853
}

resource "aws_instance" "primary_dns" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  private_ip = "10.0.0.254"
  vpc_security_group_ids = [aws_security_group.primary_dns_security.id]
  subnet_id = aws_subnet.clcom-subnet.id

  key_name = aws_key_pair.labuser.key_name

  tags = {
    Name = "primary-dns"
  }

  user_data = <<EOF
#!/bin/bash
apt update -y && apt install curl -y
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/scripts/setup_docker.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/setup_primary_dns.sh | sh
EOF
}
