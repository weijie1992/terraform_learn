provider "aws" {
  region = "ap-southeast-1"
}

locals {
  name_prefix = "weijie-"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.3.0.0/16"
  tags = {
    Name = "${local.name_prefix}vpc_main"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}internet_gateway"
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.3.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.name_prefix}subnet_public"
  }
}

# Create a route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}route_table_public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a security group
resource "aws_security_group" "instance" {
  name   = "${local.name_prefix}web_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.name_prefix}security_group_instance"
  }
}

# Launch an EC2 instance in the public subnet
resource "aws_instance" "weijieexample" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

  user_data_replace_on_change = true

  tags = {
    Name = "${local.name_prefix}test_ec2"
  }
}
