data "aws_route_table" "default" {
  vpc_id = "${aws_vpc.main.id}"

  filter {
    name   = "association.main"
    values = ["true"]
  }
}
