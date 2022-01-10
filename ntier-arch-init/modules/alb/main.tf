# Create multi zone application load balancer
resource "aws_lb" "ntier_alb" {
    name = "${format("ntier-%s-alb", var.app_layer_name)}"
    load_balancer_type = "application"
    internal = false
    security_groups = ["${var.alb_sg_id}"]
    subnets = ["${var.vpc_subnet_ids}"]

    tags {
        Name = "${format("ntier-%s-alb", var.app_layer_name)}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

# Create target group for application load balancer
resource "aws_lb_target_group" "ntier_alb_tg" {
    name = "${format("ntier-%s-alb-tg", var.app_layer_name)}"
    vpc_id = "${var.vpc_id}"
    protocol = "HTTP"
    port = 8080
    target_type = "instance"

    tags {
        Name = "${format("ntier-%s-alb-tg", var.app_layer_name)}"
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = ["aws_lb.ntier_alb"]
}

# Create https listener for application load balancer
resource "aws_lb_listener" "ntier_alb_https_listener" {
    load_balancer_arn = "${aws_lb.ntier_alb.arn}"
    protocol = "HTTPS"
    port = 443
    certificate_arn = "${var.alb_cert_arn}"

    default_action {
        type = "forward"
        target_group_arn = "${aws_lb_target_group.ntier_alb_tg.arn}"
    }
}

# Create http listener for application load balancer and redirect it to https
resource "aws_lb_listener" "ntier_alb_http_listener" {
    load_balancer_arn = "${aws_lb.ntier_alb.arn}"
    protocol = "HTTP"
    port = 80

    default_action {
        type = "redirect"

        redirect {
            protocol = "HTTPS"
            port = "443"
            status_code = "HTTP_301"
        }
    }
}
