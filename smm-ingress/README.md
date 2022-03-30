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
kubectl apply -f virtualservices-ports.yaml
```

### Step 3: Create the VirtualService(s)

### Deploy the Demo apps
Follow the instructions from the main README.md file to deploy the onlinebotique, guestbook and teastore apps

### Create TLS certs
For HTTPS connections, we need to deploy TLS certs.  
Follow these instructions
