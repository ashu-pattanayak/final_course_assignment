module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vpc"
  cidr = "10.0.0.0/16"


  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false


  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion-host-sg"
  description = "Allow SSH inbound traffic to bastion host"
  vpc_id      = module.vpc.vpc_id

 ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 tags = {
    Name = "bastion-host-sg"
  }
}


resource "aws_security_group" "private_instances_sg" {
  name        = "private-instances-sg"
  description = "Allow all inbound traffic from within the VPC"
  vpc_id      = module.vpc.vpc_id

 ingress {
    description      = "All traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.0.0.0/16"]
  }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 tags = {
    Name = "private-instances-sg"
  }
}


resource "aws_security_group" "public_web_sg" {
  name        = "public-web-sg"
  description = "Allow SSH inbound traffic to bastion host"
  vpc_id      = module.vpc.vpc_id

 ingress {
    description      = "Web"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 tags = {
    Name = "public-web-sg"
  }
}


module "ec2_instance_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
 
  name = "bastion"
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  key_name               = "Ashutosh"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "Jenkins"
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  key_name               = "Ashutosh"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.private_instances_sg.id]
  subnet_id              = module.vpc.private_subnets[0]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "app"
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  key_name               = "Ashutosh"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.private_instances_sg.id]
  subnet_id              = module.vpc.private_subnets[1]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}