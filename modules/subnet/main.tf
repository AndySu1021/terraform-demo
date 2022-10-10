resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_blocks
  availability_zone = var.availability_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "myapp-main-rtb" {
  default_route_table_id = var.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-main-rtb"
  }
}

// 創建新的路由表
//resource "aws_route_table" "myapp-rtb" {
//    vpc_id = aws_vpc.myapp-vpc.id
//    route {
//        cidr_block = "0.0.0.0/0"
//        gateway_id = aws_internet_gateway.myapp-igw.id
//    }
//    tags = {
//        Name: "${var.env_prefix}-rtb"
//    }
//}

//resource "aws_route_table_association" "myapp-rtb-subnet" {
//    subnet_id = aws_subnet.myapp-subnet-1.id
//    route_table_id = aws_route_table.myapp-rtb.id
//}
