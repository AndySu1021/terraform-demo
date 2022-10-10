terraform {
  required_version = ">= 0.12"
  //  用來指定 tfstate 檔案儲存位置
  backend "s3" {
    bucket = "myapp-bucket"
    key = "myapp/state.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

// custom defined vpc module

//resource "aws_vpc" "myapp-vpc" {
//  cidr_block = var.vpc_cidr_blocks
//  tags = {
//    Name: "${var.env_prefix}-vpc"
//  }
//}

//module "myapp-subnet" {
//  source = "./modules/subnet"
//  // variables
//  availability_zone = var.availability_zone
//  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
//  env_prefix = var.env_prefix
//  subnet_cidr_blocks = var.subnet_cidr_blocks
//  vpc_id = aws_vpc.myapp-vpc.id
//}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_blocks

  azs             = [var.availability_zone]
  public_subnets  = [var.subnet_cidr_blocks]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-server" {
  source = "./modules/webserver"
  // variables
  availability_zone = var.availability_zone
  env_prefix = var.env_prefix
  image_name = var.image_name
  instance_type = var.instance_type
  my_ip = var.my_ip
  ssh_public_key_location = var.ssh_public_key_location
  subnet_id = module.vpc.public_subnets[0]
  vpc_id = module.vpc.vpc_id
}