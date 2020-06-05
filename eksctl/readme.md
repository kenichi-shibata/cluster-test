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

Updating nodegroup
----

Update dev-cluster-1.yaml manually

Because the nodegroups are immutable you need to Delete the nodegroup. This
command will drain and delete the nodegroup

```
eksctl delete nodegroup --config-file=dev-cluster-1.yaml --include=dev-cluster-1001-stateless --approve
```

Then createonly the nodegroup since there is no need to create the control
plane again

Using the dev-cluster-1.yaml file, You can create all the workers nodegroup except the workers one with the following command:

```
eksctl create nodegroup --config-file=dev-cluster-1.yaml --exclude=dev-cluster-1001-stateless

```

Alternatively you can also create only one nodegroup

```
eksctl create nodegroup --config-file=dev-cluster-1.yaml --include=dev-cluster-1001-stateless
```

### IAM role for nodes

https://eksctl.io/usage/iam-policies/

### Managing Nodegroups

https://eksctl.io/usage/managing-nodegroups/
