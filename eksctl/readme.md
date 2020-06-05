Testing eksctl
------

```
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
```

* https://eksctl.io/introduction/


Install a cluster
------
```
eksctl create cluster -f dev-cluster-1.yaml
```

Once you create the cluster you can use gitops to deploy stuff like

```
git clone git@github:kenichi-shibata/gitops-basic
```
