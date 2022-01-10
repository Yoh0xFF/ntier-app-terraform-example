# Create security group for web load balancer
resource "aws_security_group" "ntier_web_alb_sg" {
    name = "ntier-web-alb-sg"
    vpc_id = "${var.vpc_id}"
    description = "Allow http access to web load balancer"

    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags {
        Name = "ntier-web-alb-sg"
    }
}

# Create security group for api load balancer
resource "aws_security_group" "ntier_api_alb_sg" {
    name = "ntier-api-alb-sg"
    vpc_id = "${var.vpc_id}"
    description = "Allow http access to api load balancer"

    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags {
        Name = "ntier-api-alb-sg"
    }
}

# Create security group for web ec2 instances
resource "aws_security_group" "ntier_web_asg_sg" {
    name = "ntier-web-asg-sg"
    vpc_id = "${var.vpc_id}"
    description = "Allow http access to web ec2 servers"

    ingress {
        protocol = "tcp"
        from_port = 8080
        to_port = 8080
        security_groups = ["${aws_security_group.ntier_web_alb_sg.id}"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags {
        Name = "ntier-web-asg-sg"
    }
}

# Create security group for api ec2 instances
resource "aws_security_group" "ntier_api_asg_sg" {
    name = "ntier-api-asg-sg"
    vpc_id = "${var.vpc_id}"
    description = "Allow http access to api ec2 servers"

    ingress {
        protocol = "tcp"
        from_port = 8080
        to_port = 8080
        security_groups = ["${aws_security_group.ntier_api_alb_sg.id}"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags {
        Name = "ntier-api-asg-sg"
    }
}

# Create security group for bastion ec2 instance
resource "aws_security_group" "ntier_bastion_sg" {
    name = "ntier-bastion-sg"
    vpc_id = "${var.vpc_id}"
    description = "Allow http access to api ec2 servers"

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags {
        Name = "ntier-bastion-sg"
    }
}

# Create security group for rds instance
resource "aws_security_group" "ntier_rds_sg" {
    name = "ntier-rds-sg"
    vpc_id = "${var.vpc_id}"
    description = "Allow mysql access to rds instance"

    ingress {
        protocol = "tcp"
        from_port = 3306
        to_port = 3306
        security_groups = ["${aws_security_group.ntier_api_asg_sg.id}", "${aws_security_group.ntier_bastion_sg.id}"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags {
        Name = "ntier-rds-sg"
    }
}


