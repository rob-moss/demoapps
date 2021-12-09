### Hipster Store quick start

This is created for the SMM multi-cluster demo


Run on SMM ControlPlane Cluster
```
kubectl create ns hipsterstore-multi
smm sp ai on hipsterstore-multi
kubectl -n hipsterstore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/ctlpl.yaml
```

Run on SMM Peer Cluster
```
kubectl create ns hipsterstore-multi
kubectl -n hipsterstore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/peer.yaml
```
