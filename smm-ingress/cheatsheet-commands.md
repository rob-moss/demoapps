# Cheatsheet and frequently used commands for SMM and Istio

### Set SMM dashboard to not require a login
#### smm 1.8.x
```
cat <<EOF > smm_noauth_dashboard.yaml
spec:
  backyards:
    auth:
      mode: anonymous
EOF
kubectl patch controlplane --type=merge --patch "$(cat smm_noauth_dashboard.yaml)" smm 
smm operator reconcile
```

#### smm 1.9.1+
```
cat <<EOF > smm_expose_noauth_dashboard.yaml
spec:
  smm:
    exposeDashboard:
      meshGateway:
        enabled: true
    auth:
      forceUnsecureCookies: true
      mode: anonymous
EOF
kubectl patch controlplane --type=merge --patch "$(cat smm_expose_noauth_dashboard.yaml)" smm 
smm operator reconcile
```

### Connection testing using Ubuntu container
Testing connectivity from inside the Kubernetes cluster can be performed using the below Ubuntu Pod.  You will need to install curl and/or wget. This Pod will be running on the correct Istio network and can test connectivity between attached clusters
```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: ubuntu
    istio.io/rev: cp-v112x.istio-system
    security.istio.io/tlsMode: istio
    service.istio.io/canonical-name: ubuntu
    service.istio.io/canonical-version: latest
    topology.istio.io/network: network1
  name: ubuntu
  namespace: smm-demo
spec:
  containers:
  - command:
    - sleep
    - "604800"
    image: ubuntu
    imagePullPolicy: Always
    name: ubuntu
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
EOF
sleep 10
kubectl -n smm-demo exec -it ubuntu -- /bin/bash
```

```
kubectl -n smm-demo exec -it ubuntu -- apt-get update
kubectl -n smm-demo exec -it ubuntu -- apt-get install curl wget nmap
kubectl -n smm-demo exec -it ubuntu -- /bin/bash
```

### Deploying SMM demoapp across different clusters
From help
```
smm demoapp install -s frontpage,catalog,bookings,postgresql,analytics
smm -c <PEER_CLUSTER_KUBECONFIG_FILE> demoapp install -s movies,payments,notifications,database,mysql --peer
```

### Traffic tap from CLI with extra options

```
smm tap ns/smm-system -o json |jq '. | select( .source.address.ip == "<sourceIP>")'
```

### Enable istio/smm injection on a specific namespace

```
smm sp ai on <namespace>
```

### SMM create standalone SMM gateway

This is based on SMM 1.8.2 and IKS 1.21.10

Create standalone SMM Gateway dedicated to application ingress.  This has been created in conjuction with three demo applications
- onlinebotique which is available here: https://github.com/rob-moss/demoapps/tree/main/onlineboutique
- teastore which is available here: https://github.com/rob-moss/demoapps/tree/main/teastore
- guestbook which is available here: https://github.com/rob-moss/demoapps/tree/main/guestbook




SMM documentation on how to create the IstioMeshGateway is here:
https://smm-docs.eticloud.io/docs/dashboard/gateways/create-ingress-gateway/




The prepared commands are below here. Please review the YAML to understand how it works together
```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/istiomeshgateway.yaml
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/virtualservices-hosts.yaml
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/smm-ingress/virtualservices-ports.yaml
```



This will
- Create a Namespace "smm-custom-meshgateway" for all of the below
- Create an IstioMeshGateway LoadBalancer service with public IP address as the istio ingressgateway for SMM
- Create an Istio Gateway with ports 80, 81 and 82
- Create an Istio VirtualService with ports 80, 81 and 82
- Create an Istio VirtualService with hostname matching for onlineboutique, teastore and guestbook
- Allow editing these ingress rules from the SMM GUI

Create the demo apps
```
kubectl create ns guestbook
kubectl label ns guestbook "istio.io/rev=cp-v111x.istio-system"
kubectl -n guestbook apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/guestbook/guestbook-all-in-one-clusterip.yaml

kubectl create ns teastore
kubectl label ns teastore "istio.io/rev=cp-v111x.istio-system"
kubectl -n teastore apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/teastore/teastore-clusterip.yaml

kubectl create ns onlineboutique
kubectl label ns onlineboutique "istio.io/rev=cp-v111x.istio-system"
kubectl -n onlineboutique apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml
```

Test apps
botique.172-17-50-194.nip.io -> 
frontend.onlinebotique.svc.cluster.local port 80

teastore.172-17-50-194.nip.io -> 
teastore-webui.teastore.svc.cluster.local port 8080

guestbook.172-17-50-194.nip.io -> 
frontend.guestbook.svc.cluster.local 80


Working setup from smmtest01: IKS 1.21.10 SMM 1.8.2

```
ROMOSS-M-F2M3:teastore romoss$ kubectl -n smm-system get gw,vs
NAME                                             AGE
gateway.networking.istio.io/custom-gw-v31j0      46h
gateway.networking.istio.io/smm-ingressgateway   2d5h

NAME                                                               GATEWAYS                       HOSTS                                AGE
virtualservice.networking.istio.io/any-yasj1                       ["custom-gw-v31j0"]            ["*"]                                46h
virtualservice.networking.istio.io/botique-172-17-50-194-cqp4q     ["custom-gw-v31j0"]            ["botique.172-17-50-194.nip.io"]     29h
virtualservice.networking.istio.io/guestbook-172-17-50-194-20xkc   ["custom-gw-v31j0"]            ["guestbook.172-17-50-194.nip.io"]   26h
virtualservice.networking.istio.io/smm-als                         ["istio-system/smm-als"]       ["*"]                                2d5h
virtualservice.networking.istio.io/smm-ingressgateway              ["smm-ingressgateway"]         ["*"]                                2d5h
virtualservice.networking.istio.io/smm-tracing                     ["istio-system/smm-tracing"]   ["*"]                                2d5h
virtualservice.networking.istio.io/teastore-172-17-50-194-9utz7    ["custom-gw-v31j0"]            ["teastore.172-17-50-194.nip.io"]    29h
ROMOSS-M-F2M3:teastore romoss$ kubectl -n smm-system get gw,vs,istiomeshgateway
NAME                                             AGE
gateway.networking.istio.io/custom-gw-v31j0      46h
gateway.networking.istio.io/smm-ingressgateway   2d5h

NAME                                                               GATEWAYS                       HOSTS                                AGE
virtualservice.networking.istio.io/any-yasj1                       ["custom-gw-v31j0"]            ["*"]                                46h
virtualservice.networking.istio.io/botique-172-17-50-194-cqp4q     ["custom-gw-v31j0"]            ["botique.172-17-50-194.nip.io"]     29h
virtualservice.networking.istio.io/guestbook-172-17-50-194-20xkc   ["custom-gw-v31j0"]            ["guestbook.172-17-50-194.nip.io"]   26h
virtualservice.networking.istio.io/smm-als                         ["istio-system/smm-als"]       ["*"]                                2d5h
virtualservice.networking.istio.io/smm-ingressgateway              ["smm-ingressgateway"]         ["*"]                                2d5h
virtualservice.networking.istio.io/smm-tracing                     ["istio-system/smm-tracing"]   ["*"]                                2d5h
virtualservice.networking.istio.io/teastore-172-17-50-194-9utz7    ["custom-gw-v31j0"]            ["teastore.172-17-50-194.nip.io"]    29h

NAME                                                        TYPE      SERVICE TYPE   STATUS      INGRESS IPS         ERROR   AGE    CONTROL PLANE
istiomeshgateway.servicemesh.cisco.com/custom-gw            ingress   LoadBalancer   Available   ["172.17.50.194"]           46h    {"name":"cp-v111x","namespace":"istio-system"}
istiomeshgateway.servicemesh.cisco.com/smm-ingressgateway   ingress   ClusterIP      Available   ["10.106.230.85"]           2d5h   {"name":"cp-v111x","namespace":"istio-system"}
ROMOSS-M-F2M3:teastore romoss$
```


