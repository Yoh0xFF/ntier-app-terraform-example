variable "app_layer_name" {}

variable "vpc_id" {}

variable "vpc_subnet_ids" { type = "list" }

variable "alb_cert_arn" {}

variable "alb_sg_id" {}
