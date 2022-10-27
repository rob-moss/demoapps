# Grafana Dashboard

* file: ccp-monitor-grafana.yaml
    * Grafana configmap ccp-monitor-grafana with SMTP setings modified for Cisco
* iks-crashed-pods.json
    * Grafana dashboard, import this from the Grafana Web UI
* k8s-centos-crash-pod.yaml
    * Kubernetes deployment to spawn a Pod running the centos:7 image which will constantly crash, generating a message in the Grafana dashboard

To update IKS and Grafana with SMTP settings
```
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/grafana-dashboard/ccp-monitor-grafana.yaml
kubectl -n iks delete pod -l app=grafana
kubectl apply -f https://raw.githubusercontent.com/rob-moss/demoapps/main/grafana-dashboard/k8s-centos-crash-pod.yaml
```

Browse to Grafana dashboard, import iks-crashed-pods.json
https://raw.githubusercontent.com/rob-moss/demoapps/main/grafana-dashboard/iks-crashed-pods.json
