resource "null_resource" "nginx_ingress_install" {
  provisioner "local-exec" {
    command = <<EOT
    aws eks --region ${var.region} update-kubeconfig --name ${var.cluster-name}
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/deploy.yaml
    kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s
    EOT
  }

  depends_on = [aws_eks_cluster.apps, aws_eks_node_group.demo]
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [null_resource.nginx_ingress_install]
}

data "aws_lb" "ingress-nginx" {
  name = "${element(split("-", element(split(".", data.kubernetes_service.ingress_nginx.load_balancer_ingress.0.hostname), 0)), 0)}"
  depends_on = [data.kubernetes_service.ingress_nginx]
}
