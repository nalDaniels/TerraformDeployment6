# CONFIGURE AWS PROVIDER 
provider "aws" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  alias = "west"
  region     = "us-west-2"
  #profile = "Admin"
}
# CREATE VPC
resource "aws_vpc" "d6vpcwest" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true

  tags = {
    Name = var.vpcname2 
  }
}
# CREATE SUBNETS
resource "aws_subnet" "publicsubnet3" {
  vpc_id     = aws_vpc.d6vpcwest.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.subnet3AZ
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet3name 
  }
}

resource "aws_subnet" "publicsubnet4" {
  vpc_id     = aws_vpc.d6vpcwest.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.subnet4AZ
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet4name
  }
}

# CREATE SECURITY GROUPS
resource "aws_security_group" "app_sgwest" {
  name        = var.SGNameWest 
  vpc_id = aws_vpc.d6vpcwest.id
  description = "open gunicorn port"
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.SGNameWest
    "Terraform" : "true"
  }

}


# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "gwwest" {
  vpc_id = aws_vpc.d6vpcwest.id

  tags = {
    Name = var.IGNameWest
  }
}

# CONFIGURE DEFAULT ROUTE TABLE
resource "aws_default_route_table" "routetablewest" {
  default_route_table_id = aws_vpc.d6vpcwest.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwwest.id
  }

  tags = {
    Name = var.RTnameWest
  }
}

# CREATE INSTANCES
resource "aws_instance" "application3" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sgwest.id]
  subnet_id = aws_subnet.publicsubnet3.id
  key_name = var.key_name
  associate_public_ip_address = true

  user_data = "${file("appinstall.sh")}"

  tags = {
    "Name" : var.InstanceName3
  }

}

resource "aws_instance" "application4" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sgwest.id]
  subnet_id = aws_subnet.publicsubnet4.id
  key_name = var.key_name
  associate_public_ip_address = true

  user_data = "${file("appinstall.sh")}"

  tags = {
    "Name" : var.InstanceName4 
  }

}


output "instance_ipwest" {
  value = [aws_instance.application3.public_ip, aws_instance.application4.public_ip]
}

