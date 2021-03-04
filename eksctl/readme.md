Testing eksctl
------

```
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
```

* https://eksctl.io/introduction/


Create a build cluster
---
```
eksctl create cluster -f build-cluster-1.yaml
```


Create a dev cluster
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

### Adding users to the aws-auth via iam

* https://eksctl.io/usage/iam-identity-mappings/

These are created by default on EKS creation.

Get all mappings
```
❯ eksctl get iamidentitymapping --cluster dev-cluster-1000
ARN												USERNAME				GROUPS
arn:aws:iam::012345678901:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-4ITFHC28ZVLV	system:node:{{EC2PrivateDNSName}}	system:bootstrappers,system:nodes
arn:aws:iam::012345678901:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-AR2TCRJBEHF	system:node:{{EC2PrivateDNSName}}	system:bootstrappers,system:nodes

```

This is the same as getting it from the Configmap 
```
❯ kubectl get cm -n kube-system aws-auth -o yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::029718257588:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-AR2TCRJBEHF
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::029718257588:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-4ITFHC28ZVLV
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - []
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
```

Create a mapping for my kshibata iam user. it can also be roles.
```
❯  eksctl create iamidentitymapping --cluster dev-cluster-1000 --arn arn:aws:iam::029718257588:user/kshibata --group system:users --username kshibata
```

Check again
```
❯ eksctl get iamidentitymapping --cluster dev-cluster-1000
ARN												USERNAME				GROUPS
arn:aws:iam::029718257588:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-4ITFHC28ZVLV	system:node:{{EC2PrivateDNSName}}	system:bootstrappers,system:nodes
arn:aws:iam::029718257588:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-AR2TCRJBEHF	system:node:{{EC2PrivateDNSName}}	system:bootstrappers,system:nodes
arn:aws:iam::029718257588:user/kshibata								kshibata				system:users
```

```
❯ kubectl get cm -n kube-system aws-auth -o yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::029718257588:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-AR2TCRJBEHF
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::029718257588:role/eksctl-dev-cluster-1000-nodegroup-NodeInstanceRole-4ITFHC28ZVLV
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::029718257588:user/kshibata
      username: kshibata
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
```

Now if you try to login and get pods. you will still get the errors

```
❯ export AWS_PROFILE=kshibata
❯ kubectl get pods -A
error: You must be logged in to the server (Unauthorized)
```

You need to bind the user (username) `kshibata` to a `role` or `clusterrole`. Alternatively you can use the newly created group `system:users`.

```
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kshibata-clusterrole
  namespace: rbac-system
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kshibata-clusterrolebinding
  namespace: rbac-system
subjects:
- kind: User
  name: kshibata
  namespace: rbac-system
roleRef:
  kind: ClusterRole
  name: kshibata-clusterrole
  apiGroup: rbac.authorization.k8s.io

```
try again!
```
❯ kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "kshibata" cannot list resource "nodes" in API group "" at the cluster scope
❯ kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
kubernetes-dashboard-58c67fdb89-qtjhj   1/1     Running   0          24h
```

### Adding users via oidc

* https://aws.amazon.com/blogs/containers/introducing-oidc-identity-provider-authentication-amazon-eks/

### Managing Nodegroups

https://eksctl.io/usage/managing-nodegroups/

### Logging in to Kube apiserver

All authentication method either happens through oidc or aws-iam-authenticator
* https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
