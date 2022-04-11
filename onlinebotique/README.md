## Online botique quick start

This is created for the SMM single-cluster demo

The main website is

https://github.com/GoogleCloudPlatform/microservices-demo  
https://onlineboutique.dev/  

Run the command as follows on a set of IKS clusters with SMM installed on the controlplane cluster and no addons for the Peer cluster

This guide was written using IKS 1.21.4 and the SMM addon version 1.8.2  
If you are using IKS 1.20.14 then you need to use SMM addon version 1.8.1  
No other version combinations are supported at this time  

### IKS Clusters

You will need
1 or 3 ControlPlane nodes, each with at least 2 vCPU and 16B RAM  
3 Worker nodes, each with at least 4 vCPU and 32 GB RAM  



## Quickstart commands
Deploy the IKS cluster  
Download the Kubeconfig file  
Run the commands below using the kubeconfig file  
```
export KUBECONFIG=<filename>
```

### Run on IKS cluster
```
kubectl create ns onlinebotique
smm sp ai on onlinebotique
kubectl -n onlinebotique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique/kubernetes-manifests.yaml
```

### Expose via LoadBalancer service
```
kubectl -n onlinebotique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique/frontend-lbsvc.yaml
```

### Browse to the SMM UI and select Topology
Select the namespace onlinebotique  
The toplogy should show two separate clusters with links to each of the microservices spanning across the clusters  
If not, there may be an issue with the steps above - try deleting namespaces and re-running as above  
