# Create vpc
resource "aws_vpc" "ntier" {
    cidr_block = "${var.vpc_cidr_block}"

    tags = {
        Name = "ntier"
    }
}

# Create subnet for each availability zone for database layer
resource "aws_subnet" "ntier_db_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id = "${aws_vpc.ntier.id}"
    cidr_block = "${cidrsubnet(var.vpc_cidr_block, 8, 10 + count.index)}"
    availability_zone = "${var.availability_zones[count.index]}"
    map_public_ip_on_launch = false

    tags = {
        Name = "${format("ntier-db-subnet-%s", var.availability_zones[count.index])}"
    }
}

# Create subnet for each availability zone for api layer
resource "aws_subnet" "ntier_api_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id = "${aws_vpc.ntier.id}"
    cidr_block = "${cidrsubnet(var.vpc_cidr_block, 8, 20 + count.index)}"
    availability_zone = "${var.availability_zones[count.index]}"
    map_public_ip_on_launch = true

    tags = {
        Name = "${format("ntier-api-subnet-%s", var.availability_zones[count.index])}"
    }
}

# Create subnet for each availability zone for web layer
resource "aws_subnet" "ntier_web_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id = "${aws_vpc.ntier.id}"
    cidr_block = "${cidrsubnet(var.vpc_cidr_block, 8, 30 + count.index)}"
    availability_zone = "${var.availability_zones[count.index]}"
    map_public_ip_on_launch = true

    tags = {
        Name = "${format("ntier-web-subnet-%s", var.availability_zones[count.index])}"
    }
}

# Create public route table
resource "aws_route_table" "ntier_public_route_table" {
    vpc_id = "${aws_vpc.ntier.id}"

    tags {
        Name = "ntier-public-route-table"
    }
}

# Associate public route table with api subnets
resource "aws_route_table_association" "ntier_api_subnet_route_table" {
    count = "${length(var.availability_zones)}"

    route_table_id = "${aws_route_table.ntier_public_route_table.id}"
    subnet_id = "${element(aws_subnet.ntier_api_subnet.*.id, count.index)}"
}

# Associate public route table with web subnets
resource "aws_route_table_association" "ntier_web_subnet_route_table" {
    count = "${length(var.availability_zones)}"

    route_table_id = "${aws_route_table.ntier_public_route_table.id}"
    subnet_id = "${element(aws_subnet.ntier_web_subnet.*.id, count.index)}"
}

# Create internet gateway for our vpc
resource "aws_internet_gateway" "ntier_igw" {
    vpc_id = "${aws_vpc.ntier.id}"
}

# Modify our public route table and grant public access
resource "aws_route" "ntier-internet_access" {
    route_table_id = "${aws_route_table.ntier_public_route_table.id}"
    gateway_id = "${aws_internet_gateway.ntier_igw.id}"
    destination_cidr_block = "0.0.0.0/0"
}
