# Install on EKS

https://eksctl.io/
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html


```
brew install eksctl
```


```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: romoss-calisti-panoptica01
  region: ap-southeast-1

nodeGroups:
  - name: ng-1
    instanceType: m5.xlarge
    desiredCapacity: 20
```
