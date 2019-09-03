#---------------------------------------
# VPC
#---------------------------------------
resource aws_vpc "main" {
  cidr_block = "${var.vpc_cidr}"

  tags = "${var.tags}"
}

resource aws_internet_gateway "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${var.tags}"
}

resource aws_eip "main" {
  vpc   = true
  count = "${length(var.public_subnets_cidr)}"
}

#-----------------------------------------
# Public Subnet
#-----------------------------------------
resource aws_subnet "public" {
  count = "${length(var.public_subnets_cidr)}"

  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = "${var.tags}"
}

resource aws_nat_gateway "public" {
  count = "${length(var.public_subnets_cidr)}"

  allocation_id = "${element(aws_eip.main.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource aws_route_table "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${var.tags}"
}

resource aws_route "public_to_internet" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource aws_route_table_association "public" {
  count = "${length(var.public_subnets_cidr)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

#-----------------------------------------
# Public Subnet
#-----------------------------------------
resource aws_subnet "private" {
  count = "${length(var.private_subnets_cidr)}"

  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags = "${var.tags}"
}

resource aws_route_table "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${var.tags}"
}

resource aws_route "private_to_internet" {
  count = "${length(var.private_subnets_cidr)}"

  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.public.*.id, count.index)}"
}

resource aws_route_table_association "private" {
  count = "${length(var.private_subnets_cidr)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

