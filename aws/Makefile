REGION	?= us-west-2
CLUSTER ?= terraform-eks-demo

kubeconfig:
	aws eks --region $(REGION) update-kubeconfig --name $(CLUSTER)

install-argo-cd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
