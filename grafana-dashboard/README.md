# Grafana Dashboard

* file: ccp-monitor-grafana.yaml
    * Grafana configmap ccp-monitor-grafana with SMTP setings modified for Cisco
* iks-crashed-pods.json
    * Grafana dashboard, import this from the Grafana Web UI
* k8s-centos-crash-pod.yaml
    * Kubernetes deployment to spawn a Pod running the centos:7 image which will constantly crash, generating a message in the Grafana dashboard
