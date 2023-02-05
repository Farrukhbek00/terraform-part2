resource "aws_instance" "Bastion" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = "t2.micro"

    subnet_id              = "${var.subnet_public_id}"
    vpc_security_group_ids = ["${var.sg_bastion_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: "Bastion"
    }
}

resource "aws_instance" "Public-ec2" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = "t2.micro"

    subnet_id              = "${var.subnet_public_id}"
    vpc_security_group_ids = ["${var.sg_public_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: "Public-ec2"
    }
}

resource "aws_instance" "Private-ec2" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = "t2.micro"

    subnet_id              = "${var.subnet_private_id}"
    vpc_security_group_ids = ["${var.sg_private_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: "Private-ec2"
    }
}

resource "aws_instance" "Database" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = "t2.micro"

    subnet_id              = "${var.subnet_database_id}"
    vpc_security_group_ids = ["${var.sg_database_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: "Database"
    }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key"
  public_key = tls_private_key.key.public_key_openssh
}