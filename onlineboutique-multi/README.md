## Online botique quick start

This is created for the SMM multi-cluster demo

The main website is

https://github.com/GoogleCloudPlatform/microservices-demo

https://onlineboutique.dev/

Run the command as follows on a set of IKS clusters with SMM installed on the controlplane cluster and no addons for the Peer cluster

This guide was written using IKS 1.20.4 and the SMM addon version 1.8.1

### IKS Clusters

IKS clusters you will need:
* The Controlplane cluster - this IKS cluster will have the SMM add-on installed.  This will provide the web UI for SMM.
* The Peer cluster - this is an IKS cluster with no add-ons installed. When we 'attach' the Peer cluster, the SMM installer will automatically deploy the SMM services as needed.


### Demo use case
In this demo, we have split an application in to two halves

#### Frontend
This is where the user facing web services will run from, so as to be closer to the user. In this example we are using an IKS cluster but this would traditionally be an AWS or GCP cluster out in the public cloud

#### Backend
This is where the database and data processing services will run from, so that compute resources (memory/storage) are faster and cheaper


## Quickstart commands

Run the commands below on each of the relevant clusters

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


Run on SMM Front end Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/services.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/frontend.yaml
kubectl -n onlinebotique-multi scale deployment frontend --replicas=5
```

Run on SMM Backend Cluster
```
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/services.yaml
kubectl -n onlinebotique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlinebotique-multi/backend.yaml
```

### Browse to the SMM UI and select Topology
Select the namespace onlinebotique-multi
The toplogy should show two separate clusters with links to each of the microservices spanning across the clusters
If not, there may be an issue with the steps above - try deleting namespaces and re-running as above

### Troubleshooting
* Try deleting namespaces and recreating on Controlplane first, then Peer, then run the "smm sp ai on onlinebotique-multi" command on the controlplane and check the Peer if it has received the label (takes 5-10 seconds). Once that namespace is labelled, then proceed
* Try detaching the SMM cluster and reattaching it with the --force flag
