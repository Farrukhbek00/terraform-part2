locals {
    instances = {
        instance_type = "t2.micro"
        bastion_tag   = "Bastion"
        public_tag    = "Public-ec2"
        private_tag   = "Private-ec2"
        database_tag  = "Database"
        ssh           = "ssh"
    }
}

resource "aws_instance" "Bastion" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = local.instances.instance_type

    subnet_id              = "${var.subnet_public_id}"
    vpc_security_group_ids = ["${var.sg_bastion_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: local.instances.bastion_tag
    }

    # Copies the ssh key file to home dir
    provisioner "file" {
        source      = "./${aws_key_pair.key_pair.key_name}.pem"
        destination = "/home/ubuntu/${aws_key_pair.key_pair.key_name}.pem"

        connection {
            type        = local.instances.ssh
            user        = var.ec2_user
            private_key = file("${aws_key_pair.key_pair.key_name}.pem")
            host        = self.public_ip
        }
    }
    
    //chmod key 400 on EC2 instance
    provisioner "remote-exec" {
        inline = ["chmod 400 ~/${aws_key_pair.key_pair.key_name}.pem"]

        connection {
            type        = local.instances.ssh
            user        = var.ec2_user
            private_key = file("${aws_key_pair.key_pair.key_name}.pem")
            host        = self.public_ip
        }
    }
}

resource "aws_instance" "Public-ec2" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = local.instances.instance_type

    subnet_id              = "${var.subnet_public_id}"
    vpc_security_group_ids = ["${var.sg_public_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: local.instances.public_tag
    }
}

resource "aws_instance" "Private-ec2" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = local.instances.instance_type

    subnet_id              = "${var.subnet_private_id}"
    vpc_security_group_ids = ["${var.sg_private_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: local.instances.private_tag
    }
}

resource "aws_instance" "Database" {
    ami           = "${lookup(var.ami, var.region)}"
    instance_type = local.instances.instance_type

    subnet_id              = "${var.subnet_database_id}"
    vpc_security_group_ids = ["${var.sg_database_id}"]
    key_name               = "${aws_key_pair.key_pair.id}"

    tags = {
        Name: local.instances.database_tag
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