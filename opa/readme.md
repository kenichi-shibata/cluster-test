OPA
====

Policy engine

1. Install the Gatekeeper Policy Engine
-----

**Via Helm**

```
helm3 repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts # get the gatekeeper charts
helm3 repo update # update the charts
helm3 search repo gatekeeper # check the version of gatekeeper (this was tested on 3.2.2 CHART and APPVERSION)
helm3 install gatekeeper gatekeeper/gatekeeper 
```

__NOTE:__ ignore the crd warnings they are for backwards compatibility with helm2

Follow the how to use gatekeeper walkthrough [Pinned Commit Walkthrough](https://github.com/open-policy-agent/gatekeeper/tree/13edcf98a6db7872709efbb6f1c4bd315591835d#how-to-use-gatekeeper)

**check all the components are in the right namespace**

```
NAME                                                READY   STATUS    RESTARTS   AGE
pod/gatekeeper-audit-fc7664c57-bt56s                1/1     Running   0          108m
pod/gatekeeper-controller-manager-559d6b9fb-7bmfl   1/1     Running   0          108m
pod/gatekeeper-controller-manager-559d6b9fb-b9thm   1/1     Running   0          108m
pod/gatekeeper-controller-manager-559d6b9fb-sjm9x   1/1     Running   0          108m


NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/gatekeeper-webhook-service   ClusterIP   10.100.100.142   <none>        443/TCP   108m


NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/gatekeeper-audit                1/1     1            1           108m
deployment.apps/gatekeeper-controller-manager   3/3     3            3           108m

NAME                                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/gatekeeper-audit-fc7664c57                1         1         1       108m
replicaset.apps/gatekeeper-controller-manager-559d6b9fb   3         3         3       108m

```

2. Install the contraint template for namespace 

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/basic/templates/k8srequiredlabels_template.yaml
```

Check if its installed properly. You should see the crd for `k8srequiredlabels`
```
❯ kubectl api-resources | grep gatekeeper
configs                           config             config.gatekeeper.sh             true         Config
k8srequiredlabels                                    constraints.gatekeeper.sh        false        K8sRequiredLabels
constraintpodstatuses                                status.gatekeeper.sh             true         ConstraintPodStatus
constrainttemplatepodstatuses                        status.gatekeeper.sh             true         ConstraintTemplatePodStatus
constrainttemplates                                  templates.gatekeeper.sh          false        ConstraintTemplate
```


3. Install the constraint for namespace

```
kubectl apply -f all_ns_must_have_gatekeeper.yaml
```

**Test if its working properly**

```
❯ kubectl create namespace thisshouldnotwork
Error from server ([denied by ns-must-have-gk] you must provide labels: {"gatekeeper"}): admission webhook "validation.gatekeeper.sh" denied the request: [denied by ns-must-have-gk] you must provide labels: {"gatekeeper"}
```

```
❯ kubectl apply -f namespace-fail.json
Error from server ([denied by ns-must-have-gk] you must provide labels: {"gatekeeper"}): error when creating "namespace-fail.json": admission webhook "validation.gatekeeper.sh" denied the request: [denied by ns-must-have-gk] you must provide labels: {"gatekeeper"}
```

Check the **kube-apiserver** logs if the rejection was recorded. Usually this will be recorded in the control plane audit logs

**Test the happy path**
```
❯ cat namespace-pass.json
{
   "apiVersion": "v1",
   "kind": "Namespace",
   "metadata": {
     "name": "pass",
     "labels": {
       "gatekeeper": "true"
     }
   }
 }

❯ kubectl apply -f namespace-pass.json
namespace/pass created

❯ kubectl describe ns pass
Name:         pass
Labels:       gatekeeper=true
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"v1","kind":"Namespace","metadata":{"annotations":{},"labels":{"gatekeeper":"true"},"name":"pass"}}
Status:       Active

No resource quota.

No resource limits.
```

4.
