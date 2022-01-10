output "vpc_id" {
    value = "${aws_vpc.ntier.id}"
}

output "vpc_arn" {
    value = "${aws_vpc.ntier.arn}"
}


output "vpc_db_subnet_ids" {
    value = ["${aws_subnet.ntier_db_subnet.*.id}"]
}

output "vpc_db_subnet_arns" {
    value = ["${aws_subnet.ntier_db_subnet.*.arn}"]
}

output "vpc_api_subnet_ids" {
    value = ["${aws_subnet.ntier_api_subnet.*.id}"]
}

output "vpc_api_subnet_arns" {
    value = ["${aws_subnet.ntier_api_subnet.*.arn}"]
}

output "vpc_web_subnet_ids" {
    value = ["${aws_subnet.ntier_web_subnet.*.id}"]
}

output "vpc_web_subnet_arns" {
    value = ["${aws_subnet.ntier_web_subnet.*.arn}"]
}

