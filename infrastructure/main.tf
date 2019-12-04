provider "aws" {
  profile    = "default"
  region     = "ap-northest-2"
}

resource "aws_instance" "main" {
  ami           = "ami-00379ec40a3e30f87"
  instance_type = "t2.micro"
}
