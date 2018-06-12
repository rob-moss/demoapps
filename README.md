## Kubernetes and AppD

For a detailed tutorial on how to install and configure this application for a Kubernetes cluster navigate to the [walkthrough](https://github.com/Appdynamics/AD-Capital-Docker/blob/kubernetes/Kubernetes-Walkthrough/1.md).


## Our Story

We had a multi-service application wrapped in docker that we wanted to move from on-prem to AWS w/ Kubernetes. In moving the parts to Kubernetes, we wanted to test locally before using production grade Kubernetes. The available options were Minikube and docker-for-mac (edge version with Kubernetes). While they aren't broken, then behavior was never consistent. This led to more time being spent restarting and investigating if it was us or Minikube. We also looked at a docker-compose converting function to move all of our docker-compose files to yaml files made for Kubernetes. This led to some unexpected conversions, and rather lack of general knowledge about all of the individual fields for Pods, Deployments, and Services. Long story short, don't try and cut corners by using minikube or kompose. You'll save a lot of time tinkering.

## Choosing how to deploy Kubernetes.

Our environment consists of instances on AWS, and our instance image of choice is almost always Ubuntu. Our choices were Conjure-up (open source installer for ubuntu), Kops (Production Grade K8s Installation, Upgrades, and Management. Supports running Debian, Ubuntu, CentOS, and RHEL in AWS), and CoreOS-Tectonic includes the open-source tectonic installer that creates Kubernetes clusters with Container Linux nodes on AWS. In this situation, we chose to go with conjure. We chose it because we knew kops would be fine and I prefer ubuntu specific installations because from experience ubuntu specific software plays nicer than software ported to Ubuntu.  Conjure has a really simple UI that configures with your cloud and manages the deployments via JuJu. Conjure is more simply put a wrapper for JuJu, MAAS, and LXD.

## Deploying to Kubernetes
Once we had our cluster spun up, it was time to deploy our applications to the cluster. As far as setting up your AppDynamics specific environment, the only two files that require editing are Kubernetes/env-configmap.yaml. This file contains your controller-config variables. Just fill out this file with the controller variables you use. The other file contains secrets for the account name and access key. Secrets require that the text be stored in base64. So once you have your customer name and access key. At the command line type `echo -n <your value here> | base64` . That response wull give you the base64 encoded value. Do that for both your accesskey and accountname and enter the base64 encoded values to Kubernetes/secret.yaml. Once those values have been set, you use a really simple ( kubectl create -f Kubernetes) we were able to spin up our deployment quickly and easily accessing it via the dashboard.

## Application Takeaways

- removed the need for a large startup script, each deployment with its own command
- replaced dockerize with istio (talk to this, show discovery of istio-pilot)
- init containers, removed project image, volume mounting source code
- machine agent as a daemon set
- agent logs to stdout (need to test this)

## Kubernetes Takeaways

- Port forwarding magic
- RestartPolicy
- Rolling Updates
- Init containers
- Secrets/Configs
