variable "app_name" {}

variable "app_layer_name" {}

variable "region" {
    default = "eu-central-1"
}

variable "ec2_instance_type" {
    default = "t2.micro"
}

variable "ec2_rbd_volume_type" {
    default = "gp2"
}

variable "ec2_rbd_volume_size" {
    default = 10
}
