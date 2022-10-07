# Calisti blue/green application management demo

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
kubectl -n onlineboutique-blue apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml
```


## Create the Green application

```
kubectl create ns onlineboutique-green
smm sp ai on onlineboutique-green
kubectl -n onlineboutique-green apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/onlineboutique/kubernetes-manifests.yaml
```

## Copy the Blue and Green stylesheets

```
cd /tmp
wget https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/styles-blue.css
wget https://raw.githubusercontent.com/rob-moss/demoapps/main/calisti-bluegreen/styles-green.css


pod=$(kubectl -n onlineboutique-blue get pod -l app=frontend -o name)
kubectl cp /tmp/styles-blue.css onlineboutique-blue/$pod:/src/static/styles/styles.css

pod=$(kubectl -n onlineboutique-green get pod -l app=frontend -o name)
kubectl cp /tmp/styles-green.css onlineboutique-green/$pod:/src/static/styles/styles.css

```
