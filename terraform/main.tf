# Configures Terraforms behavior for versions and AWS as the provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

# Fetching ami value for the correct Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Fetching the exisiting key-pair
data "aws_key_pair" "existing" {
  key_name   = "<key-pair-name>"
}

# Creates a t3.micro instance and runs the user_data.sh script when running
resource "aws_instance" "web" {
  ami           	 = data.aws_ami.ubuntu.id
  key_name      	 = data.aws_key_pair.existing.key_name
  instance_type 	 = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data 	 	 = file("userdata.sh")

  tags = {
    Name = "matthewpress-webserver"
  }
}

# Defines security rules for the security group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH, HTTP, HTTPS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# Creates an Elastic IP for the instance
resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id

  tags = {
    Name = "matthewpress-eip"
  }
}
