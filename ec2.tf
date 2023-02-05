resource "aws_instance" "Bastion" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    subnet_id = "${aws_subnet.public.id}"
    vpc_security_group_ids = ["${aws_security_group.SG-Bastion.id}"]
    key_name = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: "Bastion"
    }
}

resource "aws_instance" "Private-ec2" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    subnet_id = "${aws_subnet.private.id}"
    vpc_security_group_ids = ["${aws_security_group.SG-Private.id}"]
    key_name = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: "Private-ec2"
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