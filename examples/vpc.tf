locals {
  name           = "mongo"
  stage          = "Development"
  vpc_cidr_block = "10.0.0.0/16"
  default_tags = {
    Environment = "Developer"
    TF-Managed  = true
  }
}

module "vpc" {
  source                                          = "cloudposse/vpc/aws"
  version                                         = "0.28.1"
  namespace                                       = local.name
  stage                                           = local.stage
  name                                            = join("", [local.name, "-vpc"])
  cidr_block                                      = local.vpc_cidr_block
  enable_default_security_group_with_custom_rules = false
  tags                                            = local.default_tags
}

module "dynamic-subnets" {
  source             = "cloudposse/dynamic-subnets/aws"
  version            = "0.39.8"
  namespace          = local.name
  stage              = local.stage
  name               = join("", [local.name, "-instance-subnet"])
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  max_subnet_count   = 1
  availability_zones = ["us-east-1a"]
  tags               = local.default_tags
}

resource "aws_security_group" "mongo-ecs-security-group" {
  name   = local.name
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 29092
    to_port     = 29092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = local.default_tags
}
