#!/usr/bin/env bash

set -euo pipefail

# install helm in your path and rename it helm3
# https://helm.sh/docs/intro/install/
# https://github.com/helm/helm/releases

# curl -O https://get.helm.sh/helm-v3.1.1-darwin-amd64.tar.gz ~/
# tar xf helm-v3.1.1-darwin-amd64.tar.gz
# sudo mv darwin-amd64/helm ~/.local/bin

helm3 init
