provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "my_subnet"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = aws_subnet.my_subnet.id

  tags = {
    Name = "primary_network_interface"
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t1.micro"
  count         = 1

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  lifecycle {
    create_before_destroy = true
  }
}