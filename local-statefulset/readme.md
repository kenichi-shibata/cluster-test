Stateful sets
========

Failed in KinD provisioning local volumes does not work in Mac OS yet, You need to manually provision volumes. 

Follow the following operations

https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner/blob/master/docs/operations.md

https://kubernetes.io/docs/concepts/storage/volumes/#local

https://kubernetes.io/blog/2018/04/13/local-persistent-volumes-beta/

Steps taken
--------------
Tested on MacOS

```
make create3-test-statefulset

mkdir -p /mnt/data0

kubectl apply -f statefulset/stateful-nginx-namespace.yaml

kubectl apply -f statefulset/local-ssd-sc.yaml

kubectl apply -f statefulset/local-ssd-pv.yaml

kubectl apply -f statefulset/stateful-nginx.yaml
```

```
# get the events to debug
kubectl get events -n nginx-test

```
13s         Normal    WaitForFirstConsumer   persistentvolumeclaim/data-podinfo-0   waiting for first consumer to be created before binding
12s         Normal    Scheduled              pod/podinfo-0                          Successfully assigned nginx-test/podinfo-0 to prom1-worker
4s          Warning   FailedMount            pod/podinfo-0                          MountVolume.NewMounter initialization failed for volume "podinfo-vol-0" : path "/mnt/data-0" does not exist
13s         Normal    SuccessfulCreate       statefulset/podinfo                    create Claim data-podinfo-0 Pod podinfo-0 in StatefulSet podinfo success
13s         Normal    SuccessfulCreate       statefulset/podinfo                    create Pod podinfo-0 in StatefulSet podinfo successful
9m51s       Warning   FailedMount            pod/web-0                              MountVolume.NewMounter initialization failed for volume "podinfo-vol-0" : path "/mnt/data-0" does not exist
17m         Warning   FailedMount            pod/web-0                              Unable to mount volumes for pod "web-0_nginx-test(b9277f95-968d-11e9-8ad9-0242ac110004)": timeout expired waiting for volumes to attach or mount for pod "nginx-test"/"web-0". list of unmounted volumes=[www]. list of unattached volumes=[www default-token-s4s69]
```