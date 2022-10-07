# Kubernetes demo apps

These open source applications have been adapted to work in IKS and Calisti for specific customer use cases and demonstrations

In order to run these Demo Apps and the Calisti demoapps it is recommended to build a Kubernetes cluster with the following specs
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


# Calisti exposed services

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



