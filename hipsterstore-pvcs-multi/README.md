### Hipster Store quick start

This is created for the SMM multi-cluster demo

Run on Peer cluster
```
kubectl create ns hipsterstore-multi
```

Run on SMM ControlPlane Cluster
```
kubectl create ns hipsterstore-multi
smm sp ai on hipsterstore-multi
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/ctlpl.yaml
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/services-all.yaml
```

Run on SMM Peer Cluster
```
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/peer.yaml
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/services-all.yaml
```
