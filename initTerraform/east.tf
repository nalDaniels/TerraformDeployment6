# CONFIGURE AWS PROVIDER 
provider "aws" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  alias = "east"  
  region     = "us-east-1" 
  #profile = "Admin"
}
# CREATE VPC
resource "aws_vpc" "d6vpceast" {
  provider = aws.east
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true

  tags = {
    Name = var.vpcname1 
  }
}
# CREATE SUBNETS
resource "aws_subnet" "publicsubnet1" {
  provider = aws.east 
  vpc_id     = aws_vpc.d6vpceast.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.subnet1AZ
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet1name
  }
}

resource "aws_subnet" "publicsubnet2" {
  provider = aws.east 
  vpc_id     = aws_vpc.d6vpceast.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.subnet2AZ
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet2name
  }
}

# CREATE SECURITY GROUPS
resource "aws_security_group" "app_sgeast" {
  provider = aws.east
  name        = var.SGNameEast
  vpc_id = aws_vpc.d6vpceast.id
  description = "open guincorn port"
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
    "Name" : var.SGNameEast
    "Terraform" : "true"
  }

}


# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "gweast" {
  provider = aws.east
  vpc_id = aws_vpc.d6vpceast.id

  tags = {
    Name = var.IGNameEast
  }
}

# CONFIGURE DEFAULT ROUTE TABLE
resource "aws_default_route_table" "routetableeast" {
  provider = aws.east
  default_route_table_id = aws_vpc.d6vpceast.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gweast.id
  }

  tags = {
    Name = var.RTnameEast
  }
}

# CREATE INSTANCES
resource "aws_instance" "application1" {
  provider = aws.east
  ami                    = var.ami1
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sgeast.id]
  subnet_id = aws_subnet.publicsubnet1.id
  key_name = var.key_name1 
  associate_public_ip_address = true

  user_data = "${file("app.sh")}"


  tags = {
    "Name" : var.InstanceName1
  }

}

resource "aws_instance" "application2" {
  provider = aws.east
  ami                    = var.ami1
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sgeast.id]
  subnet_id = aws_subnet.publicsubnet2.id
  key_name = var.key_name1
  associate_public_ip_address = true

  user_data = "${file("app.sh")}"


  tags = {
    "Name" : var.InstanceName2
  }

}

output "instance_ipeast" {
  value = [aws_instance.application1.public_ip, aws_instance.application2.public_ip]
}

