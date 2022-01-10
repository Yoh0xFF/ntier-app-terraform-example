output "alb_id" {
    value = "${aws_lb.ntier_alb.id}"
}

output "alb_arn" {
    value = "${aws_lb.ntier_alb.arn}"
}

output "alb_tg_id" {
    value = "${aws_lb_target_group.ntier_alb_tg.id}"
}

output "alb_tg_arn" {
    value = "${aws_lb_target_group.ntier_alb_tg.arn}"
}
