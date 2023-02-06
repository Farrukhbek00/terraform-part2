variable "region" {
  default = "eu-west-1"
}

variable "ami" {
  type = map(string)

  default = {
    eu-west-1 = "ami-08ca3fed11864d6bb"
  }
}

variable "EC2_USER" {
  default = "ubuntu"
}

variable "PUBLIC_KEY_PATH" {
  default = "~/.ssh/id_rsa.pub"
}