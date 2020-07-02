resource "aws_route53_zone" "devops-australia-com" {
  name = "devops-australia.com"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.devops-australia-com.zone_id}"
  name    = "*.devops-australia.com"
  type    = "A"

  alias {
    name                   = "${module.cluster_bootstrap.ingress-nginx.dns_name}"
    zone_id                = "${module.cluster_bootstrap.ingress-nginx.zone_id}"
    evaluate_target_health = true
  }

  depends_on = [aws_route53_zone.devops-australia-com]
}