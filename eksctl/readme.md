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

Imagebuilder policy allows access to AWS ECR through Instance Profiles
Autoscaler policy allows access to ASG through instance profiles

**For more details**
- https://eksctl.io/usage/iam-policies/
- https://kubernetes.io/docs/concepts/containers/images/

### Updating kubeconfig to use aws-iam-authenticator (default)

```
eksctl utils write-kubeconfig --kubeconfig=kubeconfig-eks --cluster dev-cluster-1
```

### Scaling nodes via CLI

```
eksctl get nodegroup --cluster dev-cluster-1

CLUSTER		NODEGROUP			CREATED			MIN SIZE	MAX SIZE	DESIRED CAPACITY	INSTANCE TYPE	IMAGE ID
dev-cluster-1	dev-cluster-1001-stateless	2020-06-05T15:48:23Z	1		1		1			m5.large	ami-02e306a823081708f
dev-cluster-1	dev-cluster-1003-prometheus	2020-05-26T15:55:20Z	1		1		1			m5.xlarge	ami-023736532608ff45e
dev-cluster-1	dev-cluster-1004-spotinst	2020-05-26T15:55:20Z	  2		5		0			t3.small	ami-023736532608ff45e
dev-cluster-1	dev-cluster-1005-appmesh	2020-05-26T15:55:20Z.   1		1		1			m5.large	ami-023736532608ff45e

eksctl scale nodegroup --cluster dev-cluster-1 --name dev-cluster-1001-stateless --nodes 2

[ℹ]  scaling nodegroup stack "eksctl-dev-cluster-1-nodegroup-dev-cluster-1001-stateless" in cluster eksctl-dev-cluster-1-cluster
[ℹ]  scaling nodegroup, desired capacity from "1" to 2, max size from "1" to 2
```

### Managing Nodegroups

https://eksctl.io/usage/managing-nodegroups/


