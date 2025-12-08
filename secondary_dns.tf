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

resource "aws_vpc_security_group_ingress_rule" "sdns_allow_http" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "sdns_allow_https" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "sdns_allow_dns" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "10.0.0.28/30"
  from_port = 53
  ip_protocol = "tcp"
  to_port = 53
}

resource "aws_vpc_security_group_ingress_rule" "sdns_allow_dns_tls" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "10.0.0.28/30"
  from_port = 853
  ip_protocol = "tcp"
  to_port = 853
}

resource "aws_vpc_security_group_egress_rule" "sdns_allow_ssh_out" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "sdns_allow_http_out" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "sdns_allow_https_out" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "sdns_allow_dns_out" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 53
  ip_protocol = "tcp"
  to_port = 53
}

resource "aws_vpc_security_group_egress_rule" "sdns_allow_dns_tls_out" {
  security_group_id = aws_security_group.secondary_dns_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 853
  ip_protocol = "tcp"
  to_port = 853
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

  user_data = <<EOF
#!/bin/bash
apt update -y && apt install curl -y
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/scripts/setup_docker.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/dns-server/setup_secondary_dns.sh | sh
EOF
}
