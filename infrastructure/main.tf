provider "aws" {
  profile = "default"
  region = "${var.region_name}"
  version = "2.41.0"
}

resource "aws_instance" "ss" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
    Name = "ss"
  }
  provisioner "local-exec" {
    command = "bash bootstrap.sh"
  }
}
