# CONFIGURE AWS PROVIDER 
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
  #profile = "Admin"
}
# WILL USE DEFAULT VPC



# CREATE INSTANCES
resource "aws_instance" "jenkinsserver1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.SecurityGroup]
  subnet_id = var.Subnet
  key_name = var.key_name
  associate_public_ip_address = true
  availability_zone = var.AZ

  user_data = "${file("jenkins.sh")}"

  tags = {
    "Name" : var.InstanceName1
  }

}

resource "aws_instance" "jenkinsserver2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.SecurityGroup]
  subnet_id = var.Subnet
  key_name = var.key_name
  associate_public_ip_address = true
  availability_zone = var.AZ

  user_data = "${file("terraform.sh")}"

  tags = {
    "Name" : var.InstanceName2
  }

}

output "instance_ip" {
  value = [aws_instance.jenkinsserver1.public_ip, aws_instance.jenkinsserver2.public_ip]
}

