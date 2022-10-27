### IKS stress test


https://github.com/mohsenmottaghi/container-stress
In this scale test, to maximise the Memory and vCPU on an IKS host you should scale at least 4x containers per IKS node. For 4 nodes, run 16 containers minimum. Review vCPU/Memory in vSphere to confirm.
```
kubectl create ns stress
kubectl -n stress apply -f https://raw.githubusercontent.com/mohsenmottaghi/container-stress/master/stress-deployment.yml
kubectl -n stress scale deployment container-stress --replicas 48

kubectl delete ns stress
```


https://github.com/giantswarm/kube-stresscheck
This did not work very well
```
kubectl apply -f https://raw.githubusercontent.com/giantswarm/kube-stresscheck/master/examples/node.yaml

kubectl delete ns giantswarm
```

https://searchitoperations.techtarget.com/tutorial/Kubernetes-performance-testing-tutorial-Load-test-a-cluster
