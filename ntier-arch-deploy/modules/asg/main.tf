# Data source to query ami created by packer
data "aws_ami" "ubuntu_linux" {
    filter {
        name = "name"
        values = [
            "${format("%s-*", var.app_name)}"
        ]
    }

    most_recent = true
}

# Data source to query VPC
data "aws_vpc" "ntier_vpc" {
    filter {
        name = "tag:Name"
        values = ["ntier"]
    }
}

# Data source to query subnet
data "aws_subnet_ids" "ntier_subnet" {
    vpc_id = "${data.aws_vpc.ntier_vpc.id}"

    filter {
        name = "tag:Name"
        values = ["${format("ntier-%s-subnet-*", var.app_layer_name)}"]
    }
}

# Data source to query security group
data "aws_security_group" "ntier_asg_sg" {
    vpc_id = "${data.aws_vpc.ntier_vpc.id}"
    name = "${format("ntier-%s-asg-sg", var.app_layer_name)}"
}

# Data source to query target group
data "aws_lb_target_group" "ntier_alb_tg" {
    name = "${format("ntier-%s-alb-tg", var.app_layer_name)}"
}

# Data source to query auto scaling group instance profile
data "aws_iam_instance_profile" "ntier_asg_launch_config_instance_profile" {
    name = "ntier-asg-launch-config-instance-profile"
}

# Create auto scaling group launch configuration
resource "aws_launch_configuration" "ntier_asg_launch_config" {
    name_prefix = "${format("ntier-%s-asg-launch-config-", var.app_layer_name)}"
    image_id = "${data.aws_ami.ubuntu_linux.id}"
    instance_type = "${var.ec2_instance_type}"
    iam_instance_profile = "${data.aws_iam_instance_profile.ntier_asg_launch_config_instance_profile.name}"
    enable_monitoring = true
    key_name = "ntier-ssh-key"
    security_groups = ["${data.aws_security_group.ntier_asg_sg.id}"]

    root_block_device {
        volume_type = "${var.ec2_rbd_volume_type}"
        volume_size = "${var.ec2_rbd_volume_size}",
        delete_on_termination = true,
    }

    lifecycle {
        create_before_destroy = true
    }
}

# Create auto scaling group
resource "aws_autoscaling_group" "ntier_asg" {
    name = "${aws_launch_configuration.ntier_asg_launch_config.name}-asg"
    max_size = "${length(data.aws_subnet_ids.ntier_subnet.ids) * 3}"
    desired_capacity = "${length(data.aws_subnet_ids.ntier_subnet.ids)}"
    min_size = "${length(data.aws_subnet_ids.ntier_subnet.ids)}"
    default_cooldown = 30
    vpc_zone_identifier = ["${data.aws_subnet_ids.ntier_subnet.ids}"]
    launch_configuration = "${aws_launch_configuration.ntier_asg_launch_config.id}"
    target_group_arns = ["${data.aws_lb_target_group.ntier_alb_tg.arn}"]

    depends_on = ["aws_launch_configuration.ntier_asg_launch_config"]

    tags = [{
        key = "Name"
        value = "${format("ntier-%s-asg-instance", var.app_layer_name)}"
        propagate_at_launch = true
    }]

    lifecycle {
        create_before_destroy = true
    }
}
