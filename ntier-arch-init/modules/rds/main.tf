# Create db subnet group in vpc
resource "aws_db_subnet_group" "ntier_db_subnet_group" {
    subnet_ids = ["${var.vpc_subnet_ids}"]
    name = "ntier-db-subnet-group"
    tags = {
        Name = "ntier-db-subnet-group"
    }
}

# Create database instance in db subnet group
resource "aws_db_instance" "ntier_db_instance" {
    identifier = "ntier-db-instance"
    instance_class = "${var.rds_instance_class}"

    # engine
    engine = "mysql"
    engine_version = "5.7.16"
    auto_minor_version_upgrade = true

    # storage
    storage_type = "${var.rds_storage_type}"
    allocated_storage = "${var.rds_allocated_storage}"

    # network
    db_subnet_group_name = "${aws_db_subnet_group.ntier_db_subnet_group.name}"
    vpc_security_group_ids = ["${var.rds_sg_id}"]
    multi_az = true

    # backup
    backup_retention_period = 14
    skip_final_snapshot = true

    # monitoring
    monitoring_role_arn = "${var.ntier_rds_enhanced_monitoring_role_arn}"
    monitoring_interval = 60

    # logging
    enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

    # auth credentials
    name = "ntier"
    username = "${var.rds_admin_username}"
    password = "${var.rds_admin_password}"
}
