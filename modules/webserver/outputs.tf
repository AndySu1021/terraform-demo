output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "server" {
  value = aws_instance.myapp-server
}