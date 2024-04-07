provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_instance" "weijieexample" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t3.micro"
  subnet_id     = "subnet-010989b68ed85b33a"
  tags = {
    Name = "weijie-test-ec2"
  }
}
