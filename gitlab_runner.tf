resource "aws_security_group" "gitlab_runner_security" {
  name = "gitlab-runner-security"
  vpc_id = aws_vpc.clcom-vpc.id

  tags = {
    Name = "gitlab-runner-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "runner_allow_tls_ipv6" {
  security_group_id = aws_security_group.gitlab_runner_security.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "runner_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.gitlab_runner_security.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "gitlab_runner" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  private_ip = "10.0.0.31"
  vpc_security_group_ids = [aws_security_group.gitlab_runner_security.id]
  subnet_id = aws_subnet.clcom-subnet.id

  tags = {
    Name = "gitlab-runner"
  }

  user_data = <<EOF
apt update && apt install curl -y
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/scripts/setup_dns.sh.| sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/scripts/setup_docker.sh.| sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/if25b190/CLCOM-aws/refs/heads/main/gitlab-runner/install.sh.| sh
EOF
}
