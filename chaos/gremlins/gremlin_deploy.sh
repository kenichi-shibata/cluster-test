#!/usr/bin/env bash

set -euo pipefail

# set CLUSTER_ID
# set TEAM_ID
# set TEAM_SECRET

[ -z "$TEAM_ID" ] && echo "Empty TEAM_ID"
[ -z "$TEAM_SECRET" ] && echo "Empty TEAM_SECRET"
[ -z "$CLUSTER_ID" ] && echo "Empty CLUSTER_ID"

echo "Adding gremlin helm3 repo"

helm3 repo add gremlin https://helm.gremlin.com

echo "Creating Kubernetes Namespace gremlin"

kubectl create ns gremlin

echo "Installing gremlin daemonset"

helm3 install gremlin gremlin/gremlin \
--namespace gremlin \
--set gremlin.secret.managed=true \
--set gremlin.secret.type=secret \
--set gremlin.secret.teamID=${TEAM_ID} \
--set gremlin.secret.clusterID=${CLUSTER_ID} \
--set gremlin.secret.teamSecret=${TEAM_SECRET}
