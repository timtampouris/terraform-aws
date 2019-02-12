resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags {
    Name = "Main"
  }
}

resource "aws_subnet" "subnet1a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 0)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}a"

  tags {
    Name = "subnet1a"
  }
}

resource "aws_subnet" "subnet1b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 1)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}b"

  tags {
    Name = "subnet1b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Default GW"
  }
}

resource "aws_route_table_association" "subnet1a" {
  subnet_id      = "${aws_subnet.subnet1a.id}"
  route_table_id = "${data.aws_route_table.default.route_table_id}"
}

resource "aws_route_table_association" "subnet1b" {
  subnet_id      = "${aws_subnet.subnet1b.id}"
  route_table_id = "${data.aws_route_table.default.route_table_id}"
}

resource "aws_route" "default" {
  route_table_id         = "${data.aws_route_table.default.route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_security_group" "default" {
  name        = "Main"
  description = "Default security group allows access from MDH"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "Main"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = "true"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["YOUR-IP/32", "YOUR-IP/32"]
  }
}

/* Users */
module "bs-iam-users" {
  source = "../../../modules/awsusers"

  root_users = ["user1", "user2"]
}

resource "aws_key_pair" "root" {
  key_name   = "root"
  public_key = "ssh-rsa AAAAB3NzaCktc2EAAAAD......MwmWluk"
}
