# demoapps
Apps to demonstrate k8s features
<<<<<<< HEAD


### Guestbook quick start

```
kubectl create ns guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-lbsvc.yaml
```


### Hipster Store quick start

```
kubectl create ns hipsterstore
kubectl -n hipsterstore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs/kubernetes-manifests-lbsvc.yaml
```

### Online Botique from Google
```
kubectl create ns botique
kubectl -n botique apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
```
=======
>>>>>>> 3bc32eb (Initial commit)
