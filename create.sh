RESOURCE_GROUP=ad-capital-rg
CLUSTER_NAME=ad-capital

#if you don't have kubectl installed, you can run
#az acs kubernetes install-cli

aws group create --name $RESOURCE_GROUP --location westeurope
aws ecs create --orchestrator-type kubernetes --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --generate-ssh-keys
aws ecs kubernetes get-credentials --resource-group=$RESOURCE_GROUP  --name=$CLUSTER_NAME
kubectl create -f ./Kubernetes --validate=false
aws ecs kubernetes browse --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME
