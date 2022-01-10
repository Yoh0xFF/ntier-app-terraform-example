output "asg_launch_config_id" {
    value = "${aws_launch_configuration.ntier_asg_launch_config.id}"
}

output "asg_id" {
    value = "${aws_autoscaling_group.ntier_asg.id}"
}

output "asg_arn" {
    value = "${aws_autoscaling_group.ntier_asg.arn}"
}
