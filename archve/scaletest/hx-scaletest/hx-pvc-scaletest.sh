#!/bin/bash

# This image should be local to each IKS / CCP node. It only needs /bin/sleep and the formatting commands
# This would be ideal as busybox or some other
image=registry.ci.ciscolabs.com/cpsg_ccp/k8s.gcr.io/etcd:3.4.7

# loop 10 times
# Make a StatefulSet with 10 /data[1-10] mounts and volumes
#  Uses PVCs sourced from the Hyperflex CSI
#  StatefulSet Starts with 1 replica
# Scale up sts with following command
# kubectl scale sts busybox1 --replicas 100
# kubectl scale sts busybox2 --replicas 100
# ...
# or 
# for i in 1 2 3 4 5 6 7 8 9 10; do
#   kubectl scale sts busybox{i} --replicas 100
# done 
export storageclassname=hyperflex-csi

for i in 1 2 3 4 5 6 7 8 9 10; do
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: busybox${i}
spec:
  serviceName: "busybox${i}"
  replicas: 1
  selector:
    matchLabels:
      app: busybox
  template:
    metadata:
      labels:
        app: busybox
    spec:
      containers:
      - name: busybox
        image: $image
        command:
          - sleep
          - "86400"
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - name: data1
          mountPath: /data1
        - name: data2
          mountPath: /data2
        - name: data3
          mountPath: /data3
        - name: data4
          mountPath: /data4
        - name: data5
          mountPath: /data5
        - name: data6
          mountPath: /data6
        - name: data7
          mountPath: /data7
        - name: data8
          mountPath: /data8
        - name: data9
          mountPath: /data9
        - name: data10
          mountPath: /data10
  volumeClaimTemplates:
  - metadata:
      name: data1
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data2
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data3
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data4
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data5
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data6
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data7
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data8
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data9
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
  - metadata:
      name: data10
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: $storageclassname
      resources:
        requests:
          storage: 10Mi
EOF
done


kubectl get pvc | grep -v NAME | awk '{print $1}' | xargs kubectl delete pvc
