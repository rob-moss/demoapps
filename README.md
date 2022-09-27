# demoapps
Apps to demonstrate k8s features in the Cisco Intersight Kubernetes Service

These open source applications have been adapted to work in IKS for specific customer use cases and demonstrations

In order to run these Demo Apps and the SMM demoapp it is recommended to build and IKS cluster with the following specs
* 1 or 3 ControlPlane nodes with at least 2 vCPU and 16 GB RAM
* 3 Worker Nodes with at least 8 vCPU and 32GB RAM


# Stand alone services with LoadBalancer service

### Online Boutique from Google
```
kubectl create ns onlineboutique
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/frontend-lbsvc.yaml
```


### Guestbook
```
kubectl create ns guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-lbsvc.yaml
```


# SMM exposed services

When runing a Service Mesh Demo, deploy these applications which are deployed with a ClusterIP service and use SMM's traffic management and service exposure to use these web applications


### Online Boutique single cluster
```
kubectl create ns onlineboutique
smm sp ai on onlineboutique
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml
```

Adding a LoadBalancer service (not required for SMM)
```
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/frontend-lbsvc.yaml
```


### Guestbook
```
kubectl create ns guestbook
smm sp ai on guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml
```

### Teastore with a ClusterIP service
```
kubectl create ns teastore
smm sp ai on teastore
kubectl -n teastore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/teastore/teastore-clusterip.yaml
```



### Online botique multi-cluster

There are two clusters in use here:

SMM ControlPlane: This is the SMM Control Plane and assumed to be on-prem IKS.  
SMM Peer: This is the SMM peer cluster and can be an AWS/EKS/GCP public cloud cluster used for web services.  


Run on Peer cluster
```
kubectl create ns onlineboutique-multi
```

Run on SMM ControlPlane Cluster
```
kubectl create ns onlineboutique-multi
smm sp ai on onlineboutique-multi
```

Run on Peer cluster
```
kubectl get ns onlineboutique-multi -o yaml
```
Wait for the namespace to feature the label *"istio.io/rev: cp-v111x.istio-system"*
Do not proceed if this label has not been added to the namespace

Run on SMM ControlPlane Cluster
```
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/services.yaml
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/backend.yaml
```

Run on SMM Peer Cluster
```
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/services.yaml
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/frontend.yaml
kubectl -n onlineboutique-multi delete svc frontend-external
kubectl -n onlineboutique-multi scale deployment loadgenerator --replicas=5
```
