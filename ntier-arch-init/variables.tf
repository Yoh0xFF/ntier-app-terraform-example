variable "region" {
    default = "eu-central-1"
}

variable "availability_zones" {
    type = "list"
    default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "rds_instance_class" {
    default = "db.t2.micro"
}

variable "rds_storage_type" {
    default = "gp2"
}

variable "rds_allocated_storage" {
    default = 10
}

variable "rds_admin_username" {
    default = "root"
}

variable "rds_admin_password" {
    default = "Top_Secret_1"
}
