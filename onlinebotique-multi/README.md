### Online botique quick start

This is created for the SMM multi-cluster demo

The main website is
https://github.com/GoogleCloudPlatform/microservices-demo
https://onlineboutique.dev/

Run the command as follows on a set of IKS clusters with SMM installed on the controlplane cluster and no addons for the Peer cluster


Run on Peer cluster
```
kubectl create ns onlinebotique-multi
```

Run on SMM ControlPlane Cluster
```
kubectl create ns onlinebotique-multi
smm sp ai on onlinebotique-multi
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/ctlpl.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/services-all.yaml
```

Run on SMM Peer Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/peer.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/services-all.yaml
```
