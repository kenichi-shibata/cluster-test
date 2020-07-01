Prerequisites
-----
```
brew install aws-iam-authenticator
brew install awscli
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
# kubectl 
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/7ee32113351bbd913b90f9578bcd52dfe85d675e/Formula/kubernetes-cli.rb
# helm3 
brew install brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/0c516376e23068d65eba2ab3a95d15981a26d75c/Formula/helm.rb
```


Login using your awscli
-----

Configure role
```
# this needs to be IAM user 
aws configure
aws sts assume-role --role-arn <arn> --role-session-name multi-branch-pr-deploy-$(date +%s)

export AWS_REGION=eu-west-1
export AWS_DEFAULT_REGION=eu-west-1
export AWS_ACCESS_KEY_ID=<.Credentials.AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<.Credentials.SecretAccessKey>
export AWS_SESSION_TOKEN=<.Credentials.SessionToken>
unset AWS_SECURITY_TOKEN
```


```
# check credentials and whoami
aws sts get-caller-identity
```

Login to EKS
------

```
aws eks list-clusters
aws eks get-token --cluster-name <name above>
aws eks update-kubeconfig --kubeconfig=kubeconfig --name <name above>
export KUBECONFIG=${pwd}/kubeconfig
```

Alternate login using eksctl

```
eksctl get clusters 
eksctl utils write-kubeconfig --kubeconfig=kubeconfig-eksctl --cluster <cluster-name>
export KUBECONFIG=${pwd}/kubeconfig-eksctl
```

Test kubectl access
-----

```
kubectl get pods --all-namespaces
kubectl get namespaces
kubectl get nodes
```
