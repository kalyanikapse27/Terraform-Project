output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "vpc_id" {
  value = aws_vpc.myapp_vpc.id
  description = "VPC id"
}

output "ig_name" {
   value = lookup(var.ig_name, "Name")
  description = "Internet Gateway"
}
