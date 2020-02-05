## Export KUBECONFIG (Get this from Kenichi)
```
export KUBECONFIG=kubeconfigfile
```
## Alternatively you can get the config file by running

Assuming you have the required permissions

```
aws eks get-token --cluster-name <cluster-name>
```


## Install homebrew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## download aws-cli and aws-iam-authenticator

```
brew install aws-iam-authenticator
brew install awscli
brew install kubectl
brew install kubernetes-helm
```

## Setup your awscli
```
aws configure
```
add your access key id and secret access key

### Test
```
aws-iam-authenticator version
kubectl get --raw=/healthz
kubectl get nodes
```
## Setup the helm

```
../hack/setup_helm.sh
kubectl apply -f ../helm/sa-helm.yaml
kubectl apply -f ../helm/rbac-helm.yaml
```

## create your own namespace

```
kubectl create ns foo
kubectl config set-context --current --namespace=foo
```

## Setup Airflow

```
./airflow-setup.sh
```

## Cleanup Airflow

```
./airflow-cleanup.sh
```

## Check the pods and wait for it to be in Running state
```
kubectl get pods
kubectl get pods --namespace=foo
```

```
helm ls
helm get <name of helm deployment>
helm status <name of helm deployment>
```

get the secrets and export them and then do port-forwarding

## Setup DAGs

Read helm chart for dag setup

https://github.com/bitnami/charts/tree/master/bitnami/airflow

And do this for the innovation day

## Using kubernetes pod operator for airflow

If you want to spin up a kubernetes pod operator in airflow

You will need to setup the rbac bindings for the pods

Currently the bitnami helm chart does not support support this yet

This is why we are binding the `default` service account with the permission
to create new pods

Also change the `innovation-day` namespace in
`system:serviceaccount:innovation-day:default: to the actual namespace you
are running this as
