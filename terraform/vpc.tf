variable "name"             { default = "myio" }
variable "zones"            { default = "us-east-1b,us-east-1c" }

resource "aws_vpc" "default" {
  cidr_block            = "10.0.0.0/16"
  tags                  = { Name = "${var.name}" }
  enable_dns_support    = true
  enable_dns_hostnames  = true

}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  gateway_id             = "${aws_internet_gateway.default.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "az" {
  count                   = "${length(split(",", "${var.zones}"))}"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.${count.index*16}.0/20"
  availability_zone       = "${element(split(",", "${var.zones}"), count.index)}"
  map_public_ip_on_launch = true
}
