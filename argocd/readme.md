argocd tutorial
---------

tip: Use k9s with shift+f because of boatloads of port-forwarding its much easier

* https://blog.baeke.info/2019/12/25/giving-argo-cd-a-spin/
* https://argoproj.github.io/argo-cd/getting_started/
* https://www.youtube.com/watch?v=eyk5oKK6rDM

**download argocd cli tool**
```
brew tap argoproj/tap
brew install argoproj/tap/argocd
argocd version
```

**Create argocd namespace**
```
kubectl create namespace argocd
```

**Install argocd**
```
curl -o install.yaml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f install.yaml -n argocd
```

**Create another terminal or use & bg task**

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

**Login to argocd local and update your admin password**
```
argocd login localhost:8080
username: admin
password: <pod-name of argocd server> e.g. argocd-server-84b4bb5dd5-rc8nk

argocd account update-password
current password: argocd-server-84b4bb5dd5-rc8nk
new password: password123becausewhynotlol
```

**Check clusters added or add a new one**

```
argocd cluster add
```
Usually a serviceaccount `argocd-manager` is create in kube-system (not sure
if this is also the case if argocd is running in a separate cluster, looks
like you must bind this in a cluster-admin clusterrole if you are running it
in a separate cluster in cluster looks ok)

Checkout for details

https://argoproj.github.io/argo-cd/getting_started/#5-register-a-cluster-to-deploy-apps-to-optional


at this point you can either use argocd cli / kubectl apply / ui to deploy
applications

**Using CLI with portforwarding running**
```
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
```

**Using UI**
```
try to add this repo https://github.com/argoproj/argocd-example-apps/tree/master/sock-shop
and check if the ui can process it
make sure to get the https://github.com/argoproj/argocd-example-apps and git
and use path sock-shop
```

**Using Kubectl Apply -f**
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sock-shop-kustomize
spec:
  destination:
    namespace: default
    server: 'https://kubernetes.default.svc'
  source:
    path: sock-shop
    repoURL: 'https://github.com/argoproj/argocd-example-apps/'
    targetRevision: HEAD
  project: default
  syncPolicy: null

create above file and kubectl apply -f it
```

once you have that try opening the UI via localhost:8080 and then sync you
should see that the changes are applied and tree view is established

you can also change the syncPolicy to automate changes

```
syncPolicy:
  automated: {}
```

or to auto prune and auto heal

```
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

Using helm

```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-3-helm
spec:
  destination:
    namespace: default
    server: 'https://kubernetes.default.svc'
  source:
    path: ''
    repoURL: 'https://charts.bitnami.com/bitnami'
    targetRevision: 5.1.9
    chart: nginx
    helm:
      parameters:
        - name: ingress.enabled
          value: 'true'
        - name: readinessProbe.timeoutSeconds
          value: '10'
        - name: livenessProbe.httpGet.path
          value: /
  project: default
```

Automated
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-automated-helm
spec:
  destination:
    namespace: default
    server: 'https://kubernetes.default.svc'
  source:
    path: ''
    repoURL: 'https://charts.bitnami.com/bitnami'
    targetRevision: 5.1.7
    chart: nginx
  project: default
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
```


you can those overrides in the helm.parameters

**adding private repo**
