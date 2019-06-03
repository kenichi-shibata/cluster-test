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
```

Resources
----------
* [Makefile](https://garethr.dev/2019/05/ephemeral-kubernetes-clusters-with-kind-and-make/?utm_campaign=DevOpsLinks%20-%20Must-read%20Stories%20for%20Aspiring%20DevOps%20Professional&utm_content=%5BFaun%5D%20%F0%9F%90%AE%20DevOpsLinks%20%23167%3A%20Awesome%20Scalability%2C%20The%20Definitive%20Guide%20To%20Prometheus%20in%202019%20%26%20New%20Docker%20Vulnerability&utm_medium=email&utm_source=faun)
* [Tekton yamls](https://github.com/tektoncd/pipeline/blob/master/docs/tutorial.md)



