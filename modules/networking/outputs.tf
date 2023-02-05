output "subnet_public_id" {
  value = aws_subnet.public.id
}

output "subnet_private_id" {
  value = aws_subnet.private.id
}

output "subnet_database_id" {
  value = aws_subnet.database.id
}

output "vpc" {
  value = aws_vpc.VPC
}

output "subnet_private" {
  value = aws_subnet.private
}