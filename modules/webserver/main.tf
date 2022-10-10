resource "aws_security_group" "myapp-sg" {
  vpc_id = var.vpc_id
  name = "myapp-sg"

  // inbound rule
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // outbound rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

// 創建金鑰對
//ssh-keygen -t rsa -f ~/.ssh/myapp-key -C demo
resource "aws_key_pair" "myapp-key-pair" {
  key_name = "myapp-key"
  public_key = file(var.ssh_public_key_location)
}

// 創建 EC2
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.availability_zone

  // 指派公有 IP
  associate_public_ip_address = true
  key_name = aws_key_pair.myapp-key-pair.key_name

  tags = {
    Name: "${var.env_prefix}-myapp"
  }
}