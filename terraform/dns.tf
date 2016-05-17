resource "aws_route53_zone" "primary" {
   name = "myio.pw"
}

resource "aws_route53_zone" "internal" {
   name =     "myio.internal"
   vpc_id =   "${aws_vpc.default.id}"
}
