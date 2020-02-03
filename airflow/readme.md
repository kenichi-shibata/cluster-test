## Export KUBECONFIG (Get this from Kenichi)
```
export KUBECONFIG=kubeconfigfile
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
