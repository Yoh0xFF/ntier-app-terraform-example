# Data source to query cloudwatch agent role polocy
data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
    arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Data source to query rds enhanced monitoring role polocy
data "aws_iam_policy" "AmazonRDSEnhancedMonitoringRole" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Create assume role policy document for ec2 instance roles
data "aws_iam_policy_document" "ec2_roles_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

# Create assume role policy document for rds monitoring roles
data "aws_iam_policy_document" "rds_roles_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["monitoring.rds.amazonaws.com"]
        }
    }
}

# Create cloudwatch agent role
resource "aws_iam_role" "ntier_cloudwatch_agent_role" {
    name = "ntier-cloudwatch-agent-role"

    assume_role_policy = "${data.aws_iam_policy_document.ec2_roles_assume_role_policy.json}"

    tags {
        Name = "ntier-cloudwatch-agent-role"
    }
}
resource "aws_iam_role_policy_attachment" "sto-readonly-role-policy-attach" {
    role = "${aws_iam_role.ntier_cloudwatch_agent_role.name}"
    policy_arn = "${data.aws_iam_policy.CloudWatchAgentServerPolicy.arn}"
}

# Create rds enhanced monitoring role
resource "aws_iam_role" "ntier_rds_enhanced_monitoring_role" {
    name = "ntier-rdb-enhanced-monitoring-role"

    assume_role_policy = "${data.aws_iam_policy_document.rds_roles_assume_role_policy.json}"

    tags {
        Name = "ntier-rdb-enhanced-monitoring-role"
    }
}
resource "aws_iam_role_policy_attachment" "ntier-db-enhanced_monitoring-role-policy" {
    role = "${aws_iam_role.ntier_rds_enhanced_monitoring_role.name}"
    policy_arn = "${data.aws_iam_policy.AmazonRDSEnhancedMonitoringRole.arn}"
}

# Create auto scaling group instance profile and attach cloud watch agent role
resource "aws_iam_instance_profile" "ntier_asg_launch_config_instance_profile" {
    name = "ntier-asg-launch-config-instance-profile"
    role = "${aws_iam_role.ntier_cloudwatch_agent_role.name}"
}
