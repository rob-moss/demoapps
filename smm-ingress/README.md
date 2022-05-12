# Create an SMM Istio Mesh Gateway

The purpose of this is to create a new SMM Ingress Gateway with a public IP LoadBalancer address that can be used to manage traffic based on IP address, HTTP host header and TCP ports


SMM documentation is avialable here
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/



### Step 1: Create the IstioMeshGateway

This step will
- Create a Namespace "smm-custom-meshgateway"
- Create an IstioMeshGateway LoadBalancer service with public IP address as the istio ingressgateway for SMM


```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/istiomeshgateway.yaml
```

### Step 2: Create the Gateway
This step will create an Istio Gateway with ports 80, 81 and 82

```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/gateway.yaml
```

The Hostname to IP address DNS names may need to be updated to reflect the IP of the IstioGatewayMesh LoadBalancer IP


### Step 3: Create the VirtualService(s)

In this step we create two sets of VirtualServices (or SMM Rules).  The first one  "virtualservices-ports.yaml" forwards traffic on specific TCP ports, ie 80, 81 and 82 to specified kubernetes apps, ie onlineboutique, guestbook and teastore.  

The second file "virtualservices-hosts.yaml" uses HTTP Host header matches, so when we browse to that hostname, SMM will route traffic on to the specified kubernetes app. This example uses a hostname *.nip.io which is an online service that returns the IP address you have specified in hte hostname and will need to be updated to match your own SMM Ingress gateway's IP address, ie guestbook.172-17-50-190.nip.io returns the IP address of 172.17.50.190 which is the SMM IstioMeshGateway IP created in my Lab.  You will need to update these hostnamnes to match your IKS cluster's IstioMeshGateway IP.  

This is documented here 
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/
https://smm-docs.eticloud.io/docs/dashboard/gateways/routes-traffic-management/
https://nip.io


To create the template VirtualServices
```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/virtualservices-hosts.yaml
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/virtualservices-ports.yaml
```

Now to update the virtualservices using Hostnames will require additional steps.  First fetch the SMM ingressgateway IP address;
```
kubectl -n smm-custom-meshgateway get svc custom-gw
```

Then you can edit these Rules via the SMM Dashboard, browsing to:
- Left hand side bar
- Gateways > custom-gw
- Routes
- Click the pencil icon of each hostname rule and update the hostname

Or

Edit the virtualservices by hand with the following commands
```
kubectl -n smm-custom-meshgateway edit vs onlineboutique-hostheader
kubectl -n smm-custom-meshgateway edit vs guestbook-hostheader
kubectl -n smm-custom-meshgateway edit vs teastore-hostheader
```


### Step 4: Deploy the Demo apps
Follow the instructions from the main README.md file to deploy the onlineboutique, guestbook and teastore apps

```
kubectl create ns onlineboutique
kubectl label ns onlineboutique "istio.io/rev=cp-v111x.istio-system"
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml

kubectl create ns teastore
kubectl label ns onlineboutique "istio.io/rev=cp-v111x.istio-system"
kubectl -n teastore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/teastore/teastore-clusterip.yaml

kubectl create ns guestbook
kubectl label ns onlineboutique "istio.io/rev=cp-v111x.istio-system"
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml
```


### Step 5: Log in to SMM and review the rules

In step #3 the *.nip.io hostnames should have been updated, if not then please do that now following these instructions
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/

### Step 6: Browse to the demo apps

Open a browser and browse to the IP address from step #3

Test out HTTP port 80, 81 and 82
Also try browsing to the hostnames


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
