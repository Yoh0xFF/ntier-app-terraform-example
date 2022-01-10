output "ssh_key_id" {
    value = "${aws_key_pair.ntier_ssh_key.id}"
}

output "ssh_key_name" {
    value = "${aws_key_pair.ntier_ssh_key.key_name}"
}

output "alb_cert_id" {
    value = "${aws_iam_server_certificate.ntier_alb_cert.id}"
}

output "alb_cert_arn" {
    value = "${aws_iam_server_certificate.ntier_alb_cert.arn}"
}
