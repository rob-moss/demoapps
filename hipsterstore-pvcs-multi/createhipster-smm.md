

## Peer
```
kubectl create ns hipsterstore-multi
```

## Controlplane
```
kubectl create ns hipsterstore-multi
smm sp ai on hipsterstore-multi
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/services-all.yaml
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/ctlpl.yaml
```
## Peer
```
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/services-all.yaml
kubectl -n hipsterstore-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/peer.yaml
```

