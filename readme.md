Cluster-test
===============
Spin up an instance fast using kind and docker. 
Useful for testing Kubernetes Plugins and features.

The nodes are spun up via docker and are viewable via `docker ps`

Prerequisites
-----------
* Docker 
* Kubectl 
* Helm
* Helmfile
* jq
* watch

MacOS Quick Prereq Start
--------------
* brew install kubernetes-cli
* brew install kubernetes-helm
* brew install helmfile
* brew install jq 
* brew install watch
* https://hub.docker.com/editions/community/docker-ce-desktop-mac

Makefile cmds
--------------

Create a cluster 
```
make create-<cluster-name>
```

Get the KUBECONFIG of the created cluster
```
make env-<cluster-name>
```

List all created clusters
```
make list
```

Clean up all clusters

```
make clean
```

Login to a cluster
-------------
```
make env-cluster-1
export KUBECONFIG=<copy what's echoed>
kubectl cluster-info
kubectl get nodes
```

Create a 6 node cluster
----------
* 3 control plane node
* 3 worker node
* make sure you have at least 4 cpus and 6 gb of ram allocated to docker
```
make create6-<cluster-name>
```

Install Tiller and helm
-------------------
* Initialize helm and tiller 

```
./setup_helm.sh
```

* Its failing to startup the tiller pod

```
kubectl get deployment -n kube-system
kubectl get event -n kube-system
kubectl delete deployment tiller-deploy -n kube-system
```

* Add RBAC Roles and try again

```
kubectl apply -f sa-helm.yaml
kubectl apply -f rbac-helm.yaml
./setup_helm.sh
```

* Wait for the pod to come up 
```
watch kubectl get pods -n kube-system
```

* Check if you can connect to tiller using helm now

```
helm ls
helm version
helm repo update 
helm repo list
```

Setup helmfile and metrics server
-------------
* Install helmfile
* Run helmfile sync 
```
helmfile sync # automatically picks up helmfile.yaml to change add --file flag
```
* Initially there was a problem with metrics-server because kind uses no https endpoint so i added two args in helmfile definition 
```
    args:
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
```

Resources
----------
* [Makefile](https://garethr.dev/2019/05/ephemeral-kubernetes-clusters-with-kind-and-make/?utm_campaign=DevOpsLinks%20-%20Must-read%20Stories%20for%20Aspiring%20DevOps%20Professional&utm_content=%5BFaun%5D%20%F0%9F%90%AE%20DevOpsLinks%20%23167%3A%20Awesome%20Scalability%2C%20The%20Definitive%20Guide%20To%20Prometheus%20in%202019%20%26%20New%20Docker%20Vulnerability&utm_medium=email&utm_source=faun)
* [Tekton yamls](https://github.com/tektoncd/pipeline/blob/master/docs/tutorial.md)



