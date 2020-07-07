# resource "aws_lb" "front_end" {
#   name               = "front-end-lb-tf"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = aws_subnet.apps.*.id

#   enable_deletion_protection = false

#   tags = {
#     Environment = "production"
#   }
# }

# resource "aws_lb_listener" "front_end_https" {
#   load_balancer_arn = "${aws_lb.front_end.arn}"
#   port              = "443"
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.front_end_https.arn}"
#   }

#   depends_on = [aws_lb.front_end]
# }

# resource "aws_lb_listener" "front_end_http" {
#   load_balancer_arn = "${aws_lb.front_end.arn}"
#   port              = "80"
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.front_end_http.arn}"
#   }

#   depends_on = [aws_lb.front_end]
# }

# resource "aws_lb_target_group" "front_end_https" {
#   name     = "tf-front-end-https-lb-tg"
#   port     = 32323
#   protocol = "TCP"
#   vpc_id   = "${aws_vpc.demo.id}"

#   depends_on = [aws_vpc.demo]
# }

# resource "aws_lb_target_group" "front_end_http" {
#   name     = "tf-front-end-http-lb-tg"
#   port     = 32324
#   protocol = "TCP"
#   vpc_id   = "${aws_vpc.demo.id}"
#   depends_on = [aws_vpc.demo]
# }

# resource "aws_lb_target_group_attachment" "front_end_https" {
#   count = 2
#   target_group_arn = "${aws_lb_target_group.front_end_https.arn}"
#   target_id        = "${data.aws_instances.apps.ids[count.index]}"
#   port             = 32323

#   depends_on = [data.aws_instances.apps]
# }

# resource "aws_lb_target_group_attachment" "front_end_http" {
#   count = 2
#   target_group_arn = "${aws_lb_target_group.front_end_http.arn}"
#   target_id        = "${data.aws_instances.apps.ids[count.index]}"
#   port             = 32324

#   depends_on = [data.aws_instances.apps]
# }

# data "aws_instances" "apps" {

#   filter {
#     name   = "tag:eks:cluster-name"
#     values = ["${aws_eks_cluster.apps.name}"]
#   }

#   depends_on = [aws_eks_cluster.apps]
# }