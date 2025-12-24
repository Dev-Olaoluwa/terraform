provider "aws" {
  region = "eu-north-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "terraform_securityGroup" {
  name        = "terraform_securityGroup"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSH Key
variable "key_pair_name" {
  description = "Your AWS EC2 key pair name"
  type        = string
}

# Ubuntu EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0fa91bc90632c73c9"   # Ubuntu 22.04 LTS (Stockholm)
  instance_type = "t3.micro"
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.terraform_securityGroup.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "Fadilulahi Olasunkanmi" > /var/www/html/index.html
            EOF

  tags = {
    Name = "Terraform-Ubuntu-Web"
  }
}

# Outputs
output "vpc_id" {
  description = "VPC used by this deployment"
  value       = data.aws_vpc.default.id
}

output "subnet_ids" {
  description = "Subnets in the VPC"
  value       = data.aws_subnets.default.ids
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.terraform_securityGroup.id
}

output "instance_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}
