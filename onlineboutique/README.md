## Online botique quick start

This is created for the SMM single-cluster demo

The main website is

https://github.com/GoogleCloudPlatform/microservices-demo  
https://onlineboutique.dev/  

Run the command as follows on a set of IKS clusters with SMM installed on the controlplane cluster and no addons for the Peer cluster

This guide was written using IKS 1.21.4 and the SMM addon version 1.8.2  
If you are using and older version of IKS please upgrade to 1.21.4 or later  
No other version combinations are supported at this time  


### IKS Clusters

You will need
1 or 3 ControlPlane nodes, each with at least 2 vCPU and 16B RAM  
2 Worker nodes, each with at least 8 vCPU and 32 GB RAM  



## Quickstart commands
Deploy the IKS cluster  
Download the Kubeconfig file  
Run the commands below using the kubeconfig file  
```
export KUBECONFIG=<filename>
```

### Run on IKS cluster
```
kubectl create ns onlineboutique
smm sp ai on onlineboutique
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml
```

### Expose via LoadBalancer service
```
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/frontend-lbsvc.yaml
```

### Browse to the SMM UI and select Topology
Select the namespace onlineboutique  
The toplogy should show two separate clusters with links to each of the microservices spanning across the clusters  
If not, there may be an issue with the steps above - try deleting namespaces and re-running as above  
