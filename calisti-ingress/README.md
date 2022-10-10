# Create a Calisti Istio Mesh Gateway

The purpose of this is to create a new Calisti Ingress Gateway with a public IP LoadBalancer address that can be used to manage traffic based on IP address, HTTP host header and TCP ports

In order to run these Demo Apps and the demoapp it is recommended to build a Kubernetes cluster with the following specs
* 1 or 3 ControlPlane nodes with at least 2 vCPU and 16 GB RAM
* 3 Worker Nodes with at least 8 vCPU and 32GB RAM



Documentation is avialable here
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/


### Step 1: Deploy the Demo apps
Follow the instructions from the main README.md file to deploy the onlineboutique, guestbook and teastore apps

```
kubectl create ns onlineboutique
smm sp ai on onlineboutique
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml

kubectl create ns teastore
smm sp ai on onlineboutique
kubectl -n teastore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/teastore/teastore-clusterip.yaml

kubectl create ns guestbook
smm sp ai on onlineboutique
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml
```



### Step 2: Create the IstioMeshGateway

This step will
- Create a Namespace "smm-custom-meshgateway"
- Create an IstioMeshGateway LoadBalancer service with public IP address as the istio ingressgateway for SMM


```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-ingress/istiomeshgateway.yaml
```

### Step 3: Create the Gateway
This step will 
- Create an Istio Gateway with ports 80, 81 and 82

```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-ingress/gateway.yaml
```

The Hostname to IP address DNS names may need to be updated to reflect the IP of the IstioGatewayMesh LoadBalancer IP


### Step 4: Create the VirtualService(s)

In this step we create two sets of VirtualServices (or Calisti Rules).  The first file  "virtualservices-ports.yaml" forwards traffic on specific TCP ports, ie 80, 81 and 82 to specified kubernetes apps, ie onlineboutique, guestbook and teastore.  

The second file "virtualservices-hosts.yaml" uses HTTP Host header matches, so when we browse to that hostname, Calisti will route traffic on to the specified kubernetes app. This example uses a hostname *.nip.io which is an online service that returns the IP address you have specified in hte hostname and will need to be updated to match your own Calisti Ingress gateway's IP address, ie guestbook.172-17-50-190.nip.io returns the IP address of 172.17.50.190 which is the Calisti IstioMeshGateway IP created in my Lab.  You will need to update these hostnamnes to match your Kubernetes cluster's IstioMeshGateway IP.  

This is documented here  
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/  
https://smm-docs.eticloud.io/docs/dashboard/gateways/routes-traffic-management/  
https://nip.io  


To create the template VirtualServices
```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-ingress/virtualservices-hosts.yaml
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-ingress/virtualservices-ports.yaml
```

Now to update the virtualservices using Hostnames will require additional steps.  First fetch the Calisti ingressgateway IP address;  
```
kubectl -n smm-custom-meshgateway get svc custom-gw
```

Edit the virtualservices and replace the IP address with the IP address of your custom-gw IP, with the following commands:

```
kubectl -n smm-custom-meshgateway edit vs onlineboutique-hostheader
kubectl -n smm-custom-meshgateway edit vs guestbook-hostheader
kubectl -n smm-custom-meshgateway edit vs teastore-hostheader
```


### Step 5: Log in to Calisti and review the rules

In step #3 the *.nip.io hostnames should have been updated, if not then please do that now following these instructions
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/


### Step 6: Browse to the demo apps

Open a browser and browse to the IP address from step #4

Test out HTTP ports
* 80 - Guestbook
* 81 - Onlineboutique
* 82 - Teastore

Also try browsing to the hostnames
* teastore.x.x.x.x.nip.io
* onlineboutique.x.x.x.x.nip.io
* guestbook.x.x.x.x.nip.io













---
















# Advanced topics

### Using HTTPS/TLS connections
For HTTPS connections, we need to deploy TLS certs.  

Follow these instructions

https://smm-docs.eticloud.io/docs/convenience/lets-encrypt/?certificate


```
hostname=foo.bar.com
export hostname
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $hostname.key -out $hostname.crt -subj "/CN=$hostname"
kubectl create secret tls test-tls --key="$hostname.key" --cert="$hostname.crt" -n <namespace>
```
