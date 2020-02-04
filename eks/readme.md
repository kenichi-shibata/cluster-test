Usage
-----
```
aws configure
terraform init
terraform plan -out=eks.tfplan
terraform apply eks.tfplan
```

Setup eks cluster using module
--------
https://github.com/terraform-aws-modules/terraform-aws-eks

Setup configmap with the users or roles for login
-------
https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

kubectl get -o yaml configmap -n kube-system aws-auth
```
apiVersion: v1
data:
  mapAccounts: |
    []
  mapRoles: |
    - rolearn: arn:aws:iam::029718257588:role/airflow-cluster-gdsV0a1g20200203160949519100000002
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::xxxxx:role/engineer-role
      username: admin
      groups:
        - system:masters
    - userarn: arn:aws:iam::xxxxx:user/kenichi.shibata
      username: clusteradmin
      groups:
        - system:masters
kind: ConfigMap
metadata:
  creationTimestamp: "2020-02-03T16:10:26Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "107492"
  selfLink: /api/v1/namespaces/kube-system/configmaps/aws-auth
  uid: b09146fa-469f-11ea-9ac7-0a961e50f400
```

Annoyingly you need to `mapUsers` manually and use the `userarn` for both the user and the role arns :poop:
