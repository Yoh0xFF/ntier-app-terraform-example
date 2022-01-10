variable "rds_instance_class" {}

variable "rds_storage_type" {}

variable "rds_allocated_storage" {}

variable "rds_admin_username" {}

variable "rds_admin_password" {}

variable "vpc_subnet_ids" { type = "list" }

variable "ntier_rds_enhanced_monitoring_role_arn" {}

variable "rds_sg_id" {}
