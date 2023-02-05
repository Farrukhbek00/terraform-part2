variable "region" {
  type = string
}

variable "ami" {
  type = map(string)
}

variable "subnet_public_id" {
  type = any
}

variable "subnet_private_id" {
  type = any
}

variable "subnet_database_id" {
  type = any
}

variable "sg_bastion_id" {
  type = any
}

variable "sg_public_id" {
  type = any
}

variable "sg_private_id" {
  type = any
}

variable "sg_database_id" {
  type = any
}
