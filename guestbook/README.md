# Quick Start

### To use with a LoadBalancer service
```
kubectl create ns guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-lbsvc.yaml
```

### To use with a ClusterIP
```
kubectl create ns guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml
```
