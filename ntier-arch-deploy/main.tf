# Configure backend to store architecture state
terraform {
    backend "s3" {
        bucket = "terraform-ntier"
        encrypt = true
    }
}

# Configure aws provider
provider "aws" {
    region = "${var.region}"
}

# Create app layer based on input variable
module "asg" {
    source = "./modules/asg"

    app_name = "${var.app_name}"
    app_layer_name = "${var.app_layer_name}"

    ec2_instance_type = "${var.ec2_instance_type}"
    ec2_rbd_volume_type = "${var.ec2_rbd_volume_type}"
    ec2_rbd_volume_size = "${var.ec2_rbd_volume_size}"
}
