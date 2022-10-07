## Calisti multi-cluster demo using the Online Boutique

This is created for the Calisti multi-cluster demo

The main website is

https://github.com/GoogleCloudPlatform/microservices-demo  
https://onlineboutique.dev/  

Run the commands as follows on a set of Kubernetes clusters with Calisti installed on the controlplane cluster and no addons for the Peer cluster

This guide was written and tested using IKS 1.21.11 and Calisti version 1.8.2

## Prerequisites:

* Two Kubernetes clusters - ideally one on-prem, one in AWS or GCP
* Calisti version 1.8.2 or later deployed on the on-prem Kubernetes cluster
* Calisti ControlPlane deployed on the on-prem cluster
* AWS/GCP cluster without Calisti deployed (this will become the Peer cluster)
* Calisti ControlPlane cluster attach the Peer cluster (https://smm-docs.eticloud.io/docs/installation/multi-cluster/)  
  From ControlPlane: ```smm istio cluster attach <PEER_CLUSTER_KUBECONFIG_FILE>```
* Attach successfully links both clusters  
  From ControlPlane:  ```smm istio cluster status```


### Kubernetes Clusters

Kubernetes clusters you will need:
* The Controlplane cluster - this Kubernetes cluster will have the Calisti add-on installed.  This will provide the web UI.  
* The Peer cluster - this is an Kubernetes cluster with no add-ons installed. When we 'attach' the Peer cluster, the Calisti installer will automatically deploy the Calisti services as needed.  


### Demo use case
In this demo, we have split an application in to two halves

#### Frontend (Peer)
This is where the user facing web services will run from, so as to be closer to the user, faster and lower latency. In this example we are using an Kubernetes cluster but this would traditionally be an AWS or GCP cluster out in the public cloud.  This will be using the Peer cluster   

#### Backend (ControlPlane)
This is where the database and data processing services will run from, so that memory and cpu intensive pods are faster and cheaper to run. This will be using the ControlPlane cluster


## Quickstart commands

Run the commands below on each of the relevant clusters

Run on Peer/Frontend cluster
```
kubectl create ns onlineboutique-multi
```

Run on ControlPlane/Backend Cluster
```
kubectl create ns onlineboutique-multi
smm sp ai on onlineboutique-multi
```

Run on Peer/Frontend cluster
```
kubectl get ns onlineboutique-multi -o yaml
```
Wait for the namespace to feature the label "istio.io/rev: cp-v111x.istio-system"
Do not proceed if this label has not been added to the namespace


Run on Peer/Frontend Cluster
```
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/services.yaml
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/frontend.yaml
kubectl -n onlineboutique-multi scale deployment frontend --replicas=5
```

Run on ControlPlane/Backend Cluster
```
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/services.yaml
kubectl -n onlineboutique-multi apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique-multi/backend.yaml
```

### Browse to the Calisti UI and select Topology
* Log in to the Calisti UI and go to Topology  
* Select the namespace onlineboutique-multi  
* The toplogy should show two separate clusters with links to each of the microservices spanning across the clusters  
* If not, there may be an issue with the steps above - try deleting namespaces and re-running as above  


### Troubleshooting
* Try deleting namespaces and recreating on Controlplane first, then Peer, then run the "smm sp ai on onlineboutique-multi" command on the controlplane and check the Peer ```kubectl get ns onlineboutique-multi -o yaml``` if it has received the istio label (takes 5-10 seconds). Once that namespace is labelled, then proceed
* Try detaching the Calisti cluster and reattaching it with the --force flag
