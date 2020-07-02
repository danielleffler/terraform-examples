resource "null_resource" "nginx_ingress_install" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/deploy.yaml
    EOT
  }

  depends_on = [null_resource.module_depends_on, null_resource.wait_for_kes_crd]
}

resource "null_resource" "wait_for_ingress_nginx" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s
    EOT
  }
  depends_on = [null_resource.nginx_ingress_install]
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [null_resource.wait_for_ingress_nginx]
}

data "aws_lb" "ingress-nginx" {
  name = "${element(split("-", element(split(".", data.kubernetes_service.ingress_nginx.load_balancer_ingress.0.hostname), 0)), 0)}"
}

output "ingress-nginx" {
  value = data.aws_lb.ingress-nginx
}
