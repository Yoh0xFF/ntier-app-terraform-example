# Configure backend to store architecture state
terraform {
    backend "s3" {
        bucket = "terraform-ntier"
        key = "ntier-arch-init/state.tfstate"
        encrypt = true
        dynamodb_table = "terraform-ntier-arch-init"
    }
}

# Configure aws provider
provider "aws" {
    region = "${var.region}"
}

# Create network
module "vpc" {
    source = "modules/vpc"

    availability_zones = ["${var.availability_zones}"]

    vpc_cidr_block = "${var.vpc_cidr_block}"
}

# Create iam roles and users
module "iam" {
    source = "modules/iam"
}

# Create security groups
module "sg" {
    source = "modules/sg"

    vpc_id = "${module.vpc.vpc_id}"
}

# Create keys, certs
module "cert" {
    source = "modules/cert"
}

# Create api layer load balancer
module "alb_api" {
    source = "modules/alb"

    app_layer_name = "api"

    vpc_id = "${module.vpc.vpc_id}"
    vpc_subnet_ids = "${module.vpc.vpc_api_subnet_ids}"

    alb_cert_arn = "${module.cert.alb_cert_arn}"
    alb_sg_id = "${module.sg.api_alb_sg_id}"
}

# Create web layer load balancer
module "alb_web" {
    source = "modules/alb"

    app_layer_name = "web"

    vpc_id = "${module.vpc.vpc_id}"
    vpc_subnet_ids = "${module.vpc.vpc_web_subnet_ids}"

    alb_cert_arn = "${module.cert.alb_cert_arn}"
    alb_sg_id = "${module.sg.web_alb_sg_id}"
}

# Create database layer
module "rds" {
    source = "modules/rds"

    rds_instance_class = "${var.rds_instance_class}"
    rds_storage_type = "${var.rds_storage_type}"
    rds_allocated_storage = "${var.rds_allocated_storage}"
    rds_admin_username = "${var.rds_admin_username}"
    rds_admin_password = "${var.rds_admin_password}"

    vpc_subnet_ids = "${module.vpc.vpc_db_subnet_ids}"

    ntier_rds_enhanced_monitoring_role_arn = "${module.iam.ntier_rds_enhanced_monitoring_role_arn}"

    rds_sg_id = "${module.sg.rds_sg_id}"
}

# Create bastion server and init application database
module "bastion" {
    source = "modules/bastion"

    subnet_id = "${element(module.vpc.vpc_api_subnet_ids, 0)}"
    sg_ids = ["${module.sg.bastion_sg_id}"]

    rds_instance_endpoint = "${module.rds.ntier_db_instance_endpoint}"
    rds_admin_username = "${var.rds_admin_username}"
    rds_admin_password = "${var.rds_admin_password}"
}
