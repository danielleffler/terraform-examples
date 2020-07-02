REGION	?= us-west-2
CLUSTER ?= apps-cluster

kubeconfig:
	aws eks --region $(REGION) update-kubeconfig --name $(CLUSTER)
