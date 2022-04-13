# Create an SMM Istio Mesh Gateway

The purpose of this is to create a new SMM Ingress Gateway with a public IP LoadBalancer address that can be used to manage traffic based on IP address, HTTP host header and TCP ports


SMM documentation is avialable here
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/


### Step 1: Create the IstioMeshGateway
```
kubectl apply -f istiomeshgateway.yaml
```

### Step 2: Create the Gateway
```
kubectl apply -f gateway.yaml
```

The Hostname to IP address DNS names may need to be updated to reflect the IP of the IstioGatewayMesh LoadBalancer IP


### Step 3: Create the VirtualService(s)

```
kubectl apply -f virtualservices-ports.yaml
kubectl apply -f virtualservices-hosts.yaml
```

### Step 4: Deploy the Demo apps
Follow the instructions from the main README.md file to deploy the onlineboutique, guestbook and teastore apps

```
kubectl create ns onlineboutique
smm sp ai on onlineboutique
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml

kubectl create ns teastore
smm sp ai on teastore
kubectl -n teastore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/teastore/teastore-clusterip.yaml

kubectl create ns guestbook
smm sp ai on guestbook
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml
```


### Step 5: Create TLS certs

For HTTPS connections, we need to deploy TLS certs.  

Follow these instructions

https://smm-docs.eticloud.io/docs/convenience/lets-encrypt/?certificate


```
hostname=foo.bar.com
export hostname
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $hostname.key -out $hostname.crt -subj "/CN=$hostname"
kubectl create secret tls test-tls --key="$hostname.key" --cert="$hostname.crt" -n <namespace>
```
