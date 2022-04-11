# demoapps
Apps to demonstrate k8s features in the Cisco Intersight Kubernetes Service

These open source applications have been adapted to work in IKS for specific customer use cases and demonstrations


# Stand alone services with LoadBalancer service

### Online Botique from Google
```
kubectl create ns onlinebotique
kubectl -n onlinebotique apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
```


### Guestbook
```
kubectl create ns guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-lbsvc.yaml
```


# SMM exposed services

When runing a Service Mesh Demo, deploy these applications which are deployed with a ClusterIP service and use SMM's traffic management and service exposure to use these web applications


### Online Botique single cluster
```
kubectl create ns onlinebotique
smm sp ai on onlinebotique
kubectl -n onlinebotique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique/kubernetes-manifests.yaml
```

Adding a LoadBalancer service (not required for SMM)
```
kubectl -n onlinebotique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique/frontend-lbsvc.yaml
```


### Guestbook
```
kubectl create ns guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml
```

### Teastore with a ClusterIP service
```
kubectl create ns teastore
kubectl -n teastore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/teastore/teastore-clusterip.yaml
```



### Online botique multi-cluster

There are two clusters in use here:

SMM ControlPlane: This is the SMM Control Plane and assumed to be on-prem IKS.  
SMM Peer: This is the SMM peer cluster and can be an AWS/EKS/GCP public cloud cluster used for web services.  


Run on Peer cluster
```
kubectl create ns onlinebotique-multi
```

Run on SMM ControlPlane Cluster
```
kubectl create ns onlinebotique-multi
smm sp ai on onlinebotique-multi
```

Run on Peer cluster
```
kubectl get ns onlinebotique-multi -o yaml
```
Wait for the namespace to feature the label *"istio.io/rev: cp-v111x.istio-system"*
Do not proceed if this label has not been added to the namespace

Run on SMM ControlPlane Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/services.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/backend.yaml
```

Run on SMM Peer Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/services.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/frontend.yaml
kubectl -n onlinebotique-multi delete svc frontend-external
kubectl -n onlinebotique-multi scale deployment loadgenerator --replicas=5
```
