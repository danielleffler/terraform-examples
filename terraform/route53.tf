resource "aws_route53_zone" "tld" {
  name = "${var.domain}"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.tld.zone_id}"
  name    = "*.${var.domain}"
  type    = "A"

  alias {
    name                   = "${data.aws_lb.ingress-nginx.dns_name}"
    zone_id                = "${data.aws_lb.ingress-nginx.zone_id}"
    evaluate_target_health = true
  }

  depends_on = [aws_route53_zone.tld, data.aws_lb.ingress-nginx]
}