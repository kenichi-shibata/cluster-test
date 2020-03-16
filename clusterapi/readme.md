Create an EKS cluster or Kind v 1.14
===============

```
envsubst # install via brew install gettext && brew link --force gettext

aws-vault exec dev -- zsh
terraform plan // apply
export KUBECONFIG
```

Create Cluster API components
======

```
kubectl apply -f https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.2.9/cluster-api-components.yaml

namespace/capi-system created
customresourcedefinition.apiextensions.k8s.io/clusters.cluster.x-k8s.io created
customresourcedefinition.apiextensions.k8s.io/machinedeployments.cluster.x-k8s.io created
customresourcedefinition.apiextensions.k8s.io/machines.cluster.x-k8s.io created
customresourcedefinition.apiextensions.k8s.io/machinesets.cluster.x-k8s.io created
role.rbac.authorization.k8s.io/capi-leader-election-role created
clusterrole.rbac.authorization.k8s.io/capi-manager-role created
rolebinding.rbac.authorization.k8s.io/capi-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/capi-manager-rolebinding created
deployment.apps/capi-controller-manager created
```

Create Bootstrap Components
=============
```
kubectl apply -f https://github.com/kubernetes-sigs/cluster-api-bootstrap-provider-kubeadm/releases/download/v0.1.5/bootstrap-components.yaml

namespace/cabpk-system configured
customresourcedefinition.apiextensions.k8s.io/kubeadmconfigs.bootstrap.cluster.x-k8s.io created
customresourcedefinition.apiextensions.k8s.io/kubeadmconfigtemplates.bootstrap.cluster.x-k8s.io created
role.rbac.authorization.k8s.io/cabpk-leader-election-role created
clusterrole.rbac.authorization.k8s.io/cabpk-manager-role created
clusterrole.rbac.authorization.k8s.io/cabpk-proxy-role created
rolebinding.rbac.authorization.k8s.io/cabpk-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/cabpk-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/cabpk-proxy-rolebinding created
service/cabpk-controller-manager-metrics-service created
deployment.apps/cabpk-controller-manager created
```
Check components
=========
```
 kubectl get crd
NAME                                                CREATED AT
clusters.cluster.x-k8s.io                           2020-03-06T12:24:28Z
eniconfigs.crd.k8s.amazonaws.com                    2020-02-24T13:31:54Z
helmreleases.helm.fluxcd.io                         2020-02-25T15:35:23Z
kubeadmconfigs.bootstrap.cluster.x-k8s.io           2020-03-06T12:31:32Z
kubeadmconfigtemplates.bootstrap.cluster.x-k8s.io   2020-03-06T12:31:32Z
machinedeployments.cluster.x-k8s.io                 2020-03-06T12:24:28Z
machines.cluster.x-k8s.io                           2020-03-06T12:24:29Z
machinesets.cluster.x-k8s.io                        2020-03-06T12:24:29Z

kubectl get deploy -n capi-system

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
capi-controller-manager   1/1     1            1           11m


kubectl get deploy -n cabpk-system
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
cabpk-controller-manager   1/1     1            1           4m32s
```

Get clusterawsadm
===========
```
curl -L -o clusterawsadm https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v0.4.9/clusterawsadm-darwin-amd64
chmod +x clusterawsadm
mv clusterawsadm ~/.local/bin

 clusterawsadm
Cluster API Provider AWS commands

Usage:
  clusterawsadm [flags]
  clusterawsadm [command]

Available Commands:
  alpha       alpha commands
  help        Help about any command
  version     Print version of this binary

Flags:
  -h, --help   help for clusterawsadm

Use "clusterawsadm [command] --help" for more information about a command.
```

Get AWS Credentials
=========

`export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm alpha bootstrap encode-aws-credentials)`

```
# dont use above if you are using aws-vault
# create an aws credentials file and base64 encode it and then export that
# instead as AWS_B64ENCODED_CREDENTIALS
vi accesskey
export AWS_B64ENCODED_CREDENTIALS=`cat accesskey | base64`
```

```
curl -L https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v0.4.9/infrastructure-components.yaml > insfrastructure-components.yaml
```

Check credentials if replaced
---------------
```
cat infrastructure-components.yaml | envsubst

cat infrastructure-components.yaml | envsubst | kubectl apply -f -


 cat infrastructure-components.yaml | envsubst | kubectl apply -f -
namespace/capa-system created
customresourcedefinition.apiextensions.k8s.io/awsclusters.infrastructure.cluster.x-k8s.io created
customresourcedefinition.apiextensions.k8s.io/awsmachines.infrastructure.cluster.x-k8s.io created
customresourcedefinition.apiextensions.k8s.io/awsmachinetemplates.infrastructure.cluster.x-k8s.io created
role.rbac.authorization.k8s.io/capa-leader-election-role created
clusterrole.rbac.authorization.k8s.io/capa-manager-role created
clusterrole.rbac.authorization.k8s.io/capa-proxy-role created
rolebinding.rbac.authorization.k8s.io/capa-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/capa-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/capa-proxy-rolebinding created
secret/capa-manager-bootstrap-credentials created
service/capa-controller-manager-metrics-service created
deployment.apps/capa-controller-manager created
```

Verify installation
-----------
```
 kubectl get pods --all-namespaces
NAMESPACE      NAME                                        READY   STATUS    RESTARTS   AGE
cabpk-system   cabpk-controller-manager-7bf77b6ddb-qqdp9   2/2     Running   0          90m
capa-system    capa-controller-manager-57d7df58bc-t7vfn    1/1     Running   0          48s
capi-system    capi-controller-manager-8c944cfc9-9phn6     1/1     Running   0          97m

kubectl get crd
NAME                                                  CREATED AT
awsclusters.infrastructure.cluster.x-k8s.io           2020-03-06T14:00:45Z
awsmachines.infrastructure.cluster.x-k8s.io           2020-03-06T14:00:45Z
awsmachinetemplates.infrastructure.cluster.x-k8s.io   2020-03-06T14:00:45Z
clusters.cluster.x-k8s.io                             2020-03-06T12:24:28Z
eniconfigs.crd.k8s.amazonaws.com                      2020-02-24T13:31:54Z
kubeadmconfigs.bootstrap.cluster.x-k8s.io             2020-03-06T12:31:32Z
kubeadmconfigtemplates.bootstrap.cluster.x-k8s.io     2020-03-06T12:31:32Z
machinedeployments.cluster.x-k8s.io                   2020-03-06T12:24:28Z
machines.cluster.x-k8s.io                             2020-03-06T12:24:29Z
machinesets.cluster.x-k8s.io                          2020-03-06T12:24:29Z
```

Create your cluster
------------
```
kubectl apply -f cluster.yaml

cluster.cluster.x-k8s.io/capi-quickstart created
awscluster.infrastructure.cluster.x-k8s.io/capi-quickstart created

kubectl apply -f machine.yaml
machine.cluster.x-k8s.io/capi-quickstart-controlplane-0 created
awsmachine.infrastructure.cluster.x-k8s.io/capi-quickstart-controlplane-0 created
kubeadmconfig.bootstrap.cluster.x-k8s.io/capi-quickstart-controlplane-0 created
```

check your cluster
```
kubectl get machines --selector cluster.x-k8s.io/control-plane

```

troubleshooting
-------------

Check the aws logs via the capa controller

```
kubectl logs deploy/capa-controller-manager -n capa-system
```

Check other controllers you might need to fix your capa-bootstrap-credentials
in secrets namespace=capa-system


If eveyrthing went well you should see the machines and the clusters are
provisioned now

```
 kubectl get clusters
NAME                PHASE
capi-quickstart     provisioned


 kubectl get machines
NAME                               PROVIDERID                    PHASE
capi-quickstart-controlplane-0     aws:////i-01f1133d61426726f   running
```

Logging in
---------

```
kubectl --namespace=default get secret/capi-quickstart-kubeconfig -o json \
  | jq -r .data.value \
  | base64 --decode \
  > ./capi-quickstart.kubeconfig
```


