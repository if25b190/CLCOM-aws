resource "aws_security_group" "gitlab_server_security" {
  name = "gitlab_server_security"
  vpc_id = aws_vpc.clcom-vpc.id

  tags = {
    Name = "gitlab_server_security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_ssh" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_http" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_https" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_git" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 9418
  ip_protocol = "tcp"
  to_port = 9418
}

resource "aws_vpc_security_group_egress_rule" "server_allow_ssh_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "server_allow_http_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "server_allow_https_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "server_allow_git_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 9418
  ip_protocol = "tcp"
  to_port = 9418
}

resource "aws_vpc_security_group_egress_rule" "server_allow_ldap_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "10.0.0.10/32"
  from_port = 389
  ip_protocol = "tcp"
  to_port = 389
}

resource "aws_vpc_security_group_egress_rule" "server_allow_ldap_tls_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "10.0.0.10/32"
  from_port = 636
  ip_protocol = "tcp"
  to_port = 636
}

resource "aws_vpc_security_group_egress_rule" "server_allow_dns_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 53
  ip_protocol = "tcp"
  to_port = 53
}

resource "aws_vpc_security_group_egress_rule" "server_allow_dns_tls_out" {
  security_group_id = aws_security_group.gitlab_server_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 853
  ip_protocol = "tcp"
  to_port = 853
}

resource "aws_instance" "gitlab_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  private_ip = "10.0.0.30"
  vpc_security_group_ids = [aws_security_group.gitlab_server_security.id]
  subnet_id = aws_subnet.clcom-subnet.id

  key_name = aws_key_pair.labuser.key_name

  tags = {
    Name = "gitlab-server"
  }

  user_data = <<EOF
#!/bin/bash
apt update -y && apt install curl -y
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/scripts/setup_docker.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/gitlab-server/setup_gitlab_server.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/scripts/setup_dns.sh | sh
EOF
}
