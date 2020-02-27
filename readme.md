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

Step 1: Create a cluster
===================

You can use kind or eks

KIND Makefile cmds
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

KIND Login to a cluster
-------------
```
make create-cluster-1
make env-cluster-1
export KUBECONFIG=<copy what's echoed>
kubectl cluster-info
kubectl get nodes
```

KIND Create a 6 node cluster
----------
* 3 control plane node
* 3 worker node
* make sure you have at least 4 cpus and 6 gb of ram allocated to docker
```
make create6-<cluster-name>
```

EKS Create a cluster
------------------

```
cd eks
terraform init
terraform apply
```

EKS Authenticate with the cluster
----------------

```
aws-vault exec dev -- zsh
export KUBECONFIG=<path to repo>/eks/<Kubeconfig file>
kubectl get nodes
```

Step 2: KIND Install Tiller and helm
======================
* Initialize helm and tiller

```
./hack/setup_helm.sh
```

* Its failing to startup the tiller pod

```
kubectl get deployment -n kube-system
kubectl get event -n kube-system
kubectl delete deployment tiller-deploy -n kube-system
```

* Add RBAC Roles and try again

```
kubectl apply -f helm/sa-helm.yaml
kubectl apply -f helm/rbac-helm.yaml
./hack/setup_helm.sh
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
Check if you metrics server is working

```
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
kubectl logs deployment/metrics-server -n kube-system
kubectl top nodes
kubectl top pods -n kube-system
```

You will probably see this error message a few times, while the
metrics-server is starting up

```
Error from server (ServiceUnavailable): the server is currently unable to handle the request (get pods.metrics.k8s.io)
```

If you do not have coredns on your cluster
----------------------
* It should automatically be installed by default

Try to reach internet from inside your cluster
----------
* Install a pod with curl

```
kubectl run --image=kenichishibata/docker-curl curler
```

* Exec into the pod and run a curl command

```
export CURLER_PODNAME=$(kubectl get pods -l run=curler -o=jsonpath='{.items[0].metadata.name}')
kubectl exec -it $CURLER_PODNAME -- sh
/ # curl google.com
curl: (6) Could not resolve host: google.com
/ # nslookup google.com
nslookup: can't resolve '(null)': Name does not resolve

```
* You can see that the cluster cannot resolve any dns because coredns is not  yet installed

Install coredns on your cluster
-------------

* Use helm command
```
helm install --name coredns --namespace=kube-system stable/coredns
```
Or

* Use helmfile
```
  - name: coredns
    namespace: kube-system
    chart: stable/coredns
```
* Wait for the coredns pods to come up and start working
```
watch kubectl get pods -n kube-system

```
* To test if coredns is properly installed

```
kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools
kubectl exec -it dnstools -- sh
# host kubernetes
```

* Run curl again

```
 kubectl exec -it <curler pod name> -- sh
/ # nslookup kubernetes.default
/ # curl google.com

/ # nslookup google.com
```
* Troubleshooting https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/
* Scaling https://github.com/coredns/deployment/blob/master/kubernetes/Scaling_CoreDNS.md


Step 2: EKS Install FluxCD and HelmOperator
==================
https://github.com/fluxcd/helm-operator/blob/master/chart/helm-operator/README.md

Read what changed in helm 3

* https://helm.sh/blog/helm-3-released/
* https://helm.sh/docs/faq/#changes-since-helm-2

Install helm 3 using https://helm.sh/docs/intro/install/

Add and use the fluxcd helm repo
```
helm3 repo add fluxcd https://charts.fluxcd.io
```

Install the helmrelease crd
```
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/flux-helm-release-crd.yaml
```

Create ns
```
kubectl create ns fluxcd
```

Install Helm Operator for Helm v3 only:

```
helm3 upgrade -i helm-operator fluxcd/helm-operator \
--namespace fluxcd \
--set helm.versions=v3
```

List and get the helm operator deployment
```
helm3 list --namespace fluxcd
helm3 get all helm-operator --namespace fluxcd
```

Resources
----------
* [Makefile](https://garethr.dev/2019/05/ephemeral-kubernetes-clusters-with-kind-and-make/?utm_campaign=DevOpsLinks%20-%20Must-read%20Stories%20for%20Aspiring%20DevOps%20Professional&utm_content=%5BFaun%5D%20%F0%9F%90%AE%20DevOpsLinks%20%23167%3A%20Awesome%20Scalability%2C%20The%20Definitive%20Guide%20To%20Prometheus%20in%202019%20%26%20New%20Docker%20Vulnerability&utm_medium=email&utm_source=faun)
* [Tekton yamls](https://github.com/tektoncd/pipeline/blob/master/docs/tutorial.md)



