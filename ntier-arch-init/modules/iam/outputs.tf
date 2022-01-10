output "ntier_cloudwatch_agent_role_id" {
    value = "${aws_iam_role.ntier_cloudwatch_agent_role.id}"
}

output "ntier_cloudwatch_agent_role_arn" {
    value = "${aws_iam_role.ntier_cloudwatch_agent_role.arn}"
}


output "ntier_rds_enhanced_monitoring_role_id" {
    value = "${aws_iam_role.ntier_rds_enhanced_monitoring_role.id}"
}

output "ntier_rds_enhanced_monitoring_role_arn" {
    value = "${aws_iam_role.ntier_rds_enhanced_monitoring_role.arn}"
}
