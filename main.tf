provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_instance" "weijieexample" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t3.micro"
  subnet_id     = "subnet-010989b68ed85b33a"

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohub busybox httpd -f -p 8080 &
                EOF

  user_data_replace_on_change = true
  tags = {
    Name = "weijie-test-ec2"
  }
}

resource "aws_security_group" "instance" {
  name   = "web"
  vpc_id = "vpc-019f9d41bb7961d02"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
