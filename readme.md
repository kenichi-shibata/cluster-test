Cluster-test
===============
Spin up an instance fast using kind and docker. 
Useful for testing Kubernetes Plugins and features.

The nodes are spun up via docker and are viewable via `docker ps`

Makefile cmds
--------------

Create a cluster 
```
make create-<cluster-name>
```

Get the KUBECONFIG of the created cluster
```
make env-<cluster-name>
```

List all created clusters
```
make list
```

Clean up all clusters

```
make clean
``



