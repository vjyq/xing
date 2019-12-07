provider "aws" {
  profile = "default"
  region = "${var.region_name}"
  version = "2.41.0"
}

resource "aws_vpc" "xing" {
  cidr_block = "${var.cidr}"
  tags = {
    Name = "xing_vpc"
  }
}

resource "aws_security_group" "xing" {
  name = "xing_sg"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "xing_sg"
  }
  vpc_id = "${aws_vpc.xing.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.xing.id}"
  cidr_block = "${var.cidr_public_subnet}"
  tags = {
    Name = "xing_cidr_public_subnet"
  }
}

resource "aws_instance" "xing" {
  ami = "${var.ami_id}"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  provisioner "local-exec" {
    command = "bash bootstrap.sh"
  }
  subnet_id = "${aws_subnet.public.id}"
  tags = {
    Name = "xing_instance"
  }
  vpc_security_group_ids = ["${aws_security_group.xing.id}"]
}

output "xing_instance_public_ip" {
  value = "${aws_instance.xing.public_ip}"
}
