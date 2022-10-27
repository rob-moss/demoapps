#!/bin/bash

kubectl create ns stress
kubectl -n stress apply -f https://raw.githubusercontent.com/mohsenmottaghi/container-stress/master/stress-deployment.yml
kubectl -n stress scale deployment container-stress --replicas 16
