# Create key pair to allow ssh access to ec2 instances
resource "aws_key_pair" "ntier_ssh_key" {
    key_name = "ntier-ssh-key"
    public_key = "${file("${path.module}/secret/ssh/aws_id_rsa.key.pub.pem")}"
}

# Create IAM certificate for load balancer https listener
resource "aws_iam_server_certificate" "ntier_alb_cert" {
    name = "ntier-alb-cert"
    certificate_body = "${file("${path.module}/secret/crt/aws.crt.pem")}"
    private_key = "${file("${path.module}/secret/crt/aws.key.pem")}"
}
