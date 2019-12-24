provider "aws" {
  profile = "default"
  region = "${var.region_name}"
  version = "2.41.0"
}

resource "aws_vpc" "xing_vpc" {
  cidr_block = "${var.cidr}"
  tags = {
    Name = "xing_vpc"
  }
}

resource "aws_subnet" "xing_vpc_subnet_public" {
  availability_zone = "ap-northeast-1a"
  cidr_block = "${var.cidr_subnet_public}"
  tags = {
    Name = "xing_vpc_subnet_public"
  }
  vpc_id = "${aws_vpc.xing_vpc.id}"
}

resource "aws_internet_gateway" "xing_vpc_ig" {
  tags = {
    Name = "xing_vpc_ig"
  }
  vpc_id = "${aws_vpc.xing_vpc.id}"
}

resource "aws_route_table" "xing_vpc_subnet_route" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.xing_vpc_ig.id}"
  }
  tags = {
    Name = "xing_vpc_subnet_route"
  }
  vpc_id = "${aws_vpc.xing_vpc.id}"
}

resource "aws_route_table_association" "xing_vpc_subnet_route_public"{
  subnet_id = "${aws_subnet.xing_vpc_subnet_public.id}"
  route_table_id = "${aws_route_table.xing_vpc_subnet_route.id}"
}

resource "aws_security_group" "xing_sg_ssh" {
  name = "xing_sg_ssh"
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
    Name = "xing_sg_ssh"
  }
  vpc_id = "${aws_vpc.xing_vpc.id}"
}

resource "aws_instance" "xing_instance" {
  ami = "${var.ami_id}"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("${var.key_path}")}"
      host     = "${self.public_ip}"
    }
    source      = "bootstrap.sh"
    destination = "bootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("${var.key_path}")}"
      host     = "${self.public_ip}"
    }
    inline = [
      "chmod +x bootstrap.sh",
      "bash bootstrap.sh",
    ]
  }
  subnet_id = "${aws_subnet.xing_vpc_subnet_public.id}"
  tags = {
    Name = "xing_instance"
  }
  vpc_security_group_ids = ["${aws_security_group.xing_sg_ssh.id}"]
}

output "xing_instance_public_ip" {
  value = "${aws_instance.xing_instance.public_ip}"
}
