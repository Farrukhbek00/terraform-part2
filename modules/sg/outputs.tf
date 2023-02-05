output "sg_bastion_id" {
  value = aws_security_group.SG-Bastion.id
}

output "sg_public_id" {
  value = aws_security_group.SG-Public.id
}

output "sg_private_id" {
  value = aws_security_group.SG-Private.id
}

output "sg_database_id" {
  value = aws_security_group.SG-Database.id
}