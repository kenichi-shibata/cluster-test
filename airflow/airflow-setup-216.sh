#!/usr/bin/env bash

set -euo pipefail

helm216 repo add bitnami https://charts.bitnami.com/bitnami
helm216 repo update bitnami
helm216 install --name airflow-poc bitnami/airflow
echo "export the env variables"
echo "cat airflow-helm.sh and run the last bit"
#helm216 upgrade airflow-poc bitnami/airflow  \
#--set airflow.loadExamples=true \
#--set service.type=ClusterIP,airflow.baseUrl=http://$APP_HOST:$APP_PORT,airflow.auth.password=$APP_PASSWORD,postgresql.postgresqlPassword=$APP_DATABASE_PASSWORD,redis.password=$APP_REDIS_PASSWORD \

