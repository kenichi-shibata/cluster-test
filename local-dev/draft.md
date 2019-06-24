Setup draft for local dev with a kube cluster
-----------

Install draft 
```
brew install azure/draft/draft 
```

Initialize draft
```
draft init # Initializes in ~/.draft
draft create # created the draft dockerfile, chart and other artifacts to deploy to kubernetes
draft config set registry docker.io/kenichishibata # set the docker registry
draft up #deploys the created helm chart
```
