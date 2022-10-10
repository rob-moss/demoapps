# Calisti blue/green application management demo

## Prerequisites:

Using the Calisti Ingress Gateway demo shown here https://github.com/rob-moss/demoapps/tree/main/calisti-ingress we can use this same method to switch between two different versions of applications, using the same Blue/Green methodology


## Method

We deploy two copies of the onlineboutique demo application.
In the Blue application, we modify one of the stylesheets to show the text colour as Blue
In the Green application, we modify one of the stylesheets to show the text colour as Green
We create the Calisti gateway using steps #2 and onwards from here https://github.com/rob-moss/demoapps/tree/main/calisti-ingress#step-2-create-the-istiomeshgateway


## Create the Blue application

```
kubectl create ns onlineboutique-blue
smm sp ai on onlineboutique-blue
kubectl -n onlineboutique-blue apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/onlineboutique-blue.yaml
```


## Create the Green application

```
kubectl create ns onlineboutique-green
smm sp ai on onlineboutique-green
kubectl -n onlineboutique-green apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/onlineboutique-green.yaml
```

## Add the Gateways

We create the Calisti gateway using steps #2 and onwards from here https://github.com/rob-moss/demoapps/tree/main/calisti-ingress#step-2-create-the-istiomeshgateway

If the gateway has already been created, then skip down to just the section below that creates the VirtualServices

```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/virtualservices-hosts.yaml
```

The virtualservices may need to be edited to use the correct IP address for your Calisi Ingress Gateway


Now to update the virtualservices using Hostnames will require additional steps.  First fetch the Calisti ingressgateway IP address;  
```
kubectl -n smm-custom-meshgateway get svc custom-gw
```

Edit the virtualservices and replace the IP address with the IP address of your custom-gw IP, with the following commands:

```
kubectl -n smm-custom-meshgateway edit vs onlineboutique-green
kubectl -n smm-custom-meshgateway edit vs onlineboutique-blue
```

## Test the services

Open a browser to the hostnames below (replace x-x-x-x with the IP of your Calisti ingress gateway)
* onlineboutique-blue.x-x-x-x.nip.ip
* onlineboutique-green.x-x-x-x.nip.ip
* onlineboutique-bgprod.x-x-x-x.nip.ip

   
## Upgrade the Green app

We will then upgrade the green app from v0.3.6 to v0.3.7 by editing the frontend Deployment image: statement
  
```
kubectl -n onlineboutique-green edit deploy frontend
```

Update the ```image:``` statement with ```romoss/frontend:v0.3.7-green```

Watch the old Pod Terminate and the new one start up


---

# Manual steps, no longer necessary

## Copy the Blue and Green stylesheets

The stylesheets below will colour the text from dark Gray to dark Blue and Green respectively

```
cd /tmp
wget -q https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/styles-blue.css
wget -q https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/styles-green.css


pod=$(kubectl -n onlineboutique-blue get pod -l app=frontend -o jsonpath='{.items..metadata.name}')
kubectl cp /tmp/styles-blue.css onlineboutique-blue/$pod:/src/static/styles/styles.css

pod=$(kubectl -n onlineboutique-green get pod -l app=frontend -o jsonpath='{.items..metadata.name}')
kubectl cp /tmp/styles-green.css onlineboutique-green/$pod:/src/static/styles/styles.css
```
