// 打印 EC2 IP
output "ec2_public_ip" {
  value = module.myapp-server.server.public_ip
}