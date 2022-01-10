data "aws_ami" "ubuntu_linux" {
    filter {
        name = "name"
        values = ["ami-ubuntu-18.04-*"]
    }

    owners = ["258751437250"]

    most_recent = true
}

resource "aws_instance" "ntier_bastion" {
    ami = "${data.aws_ami.ubuntu_linux.id}"
    instance_type = "t2.micro"

    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${var.sg_ids}"]
    key_name = "ntier-ssh-key"

    associate_public_ip_address = true

    tags {
        Name = "ntier-bastion"
    }
}
