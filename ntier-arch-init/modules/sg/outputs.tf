output "web_alb_sg_id" {
    value = "${aws_security_group.ntier_web_alb_sg.id}"
}

output "web_alb_sg_arn" {
    value = "${aws_security_group.ntier_web_alb_sg.arn}"
}

output "api_alb_sg_id" {
    value = "${aws_security_group.ntier_api_alb_sg.id}"
}

output "api_alb_sg_arn" {
    value = "${aws_security_group.ntier_api_alb_sg.arn}"
}

output "web_asg_sg_id" {
    value = "${aws_security_group.ntier_web_asg_sg.id}"
}

output "web_asg_sg_arn" {
    value = "${aws_security_group.ntier_web_asg_sg.arn}"
}

output "api_asg_sg_id" {
    value = "${aws_security_group.ntier_api_asg_sg.id}"
}

output "api_asg_sg_arn" {
    value = "${aws_security_group.ntier_api_asg_sg.arn}"
}

output "bastion_sg_id" {
    value = "${aws_security_group.ntier_bastion_sg.id}"
}

output "bastion_sg_arn" {
    value = "${aws_security_group.ntier_bastion_sg.arn}"
}


output "rds_sg_id" {
    value = "${aws_security_group.ntier_rds_sg.id}"
}

output "rds_sg_arn" {
    value = "${aws_security_group.ntier_rds_sg.arn}"
}
