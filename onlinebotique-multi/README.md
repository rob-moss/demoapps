### Online botique quick start

This is created for the SMM multi-cluster demo

The main website is
https://github.com/GoogleCloudPlatform/microservices-demo
https://onlineboutique.dev/

Run the command as follows on a set of IKS clusters with SMM installed on the controlplane cluster and no addons for the Peer cluster

### Quickstart commands

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
Wait for the namespace to feature the label "istio.io/rev: cp-v111x.istio-system"
Do not proceed if this label has not been added to the namespace


Run on SMM ControlPlane Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/services.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/controlpl.yaml
```

Run on SMM Peer Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/services.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/hipsterstore-pvcs-multi/peer.yaml
```

Browse to the SMM UI and select Topology
Select the namespace onlinebotique-multi
The toplogy should show two separate clusters with links to each of the microservices spanning across the clusters
If not, there may be an issue with the steps above - try deleting namespaces and re-running as above

Troubleshooting
* Try deleting namespaces and recreating on Controlplane first, then Peer, then run the "smm sp ai on onlinebotique-multi" command on the controlplane and check the Peer if it has received the label (takes 5-10 seconds). Once that namespace is labelled, then proceed
* Try detaching the SMM cluster and reattaching it with the --force flag