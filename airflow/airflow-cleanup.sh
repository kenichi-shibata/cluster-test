#!/usr/bin/env bash

set -euo pipefail

helm delete --purge airflow-poc
unset APP_HOST
unset APP_PORT
unset APP_PASSWORD
unset APP_DATABASE_PASSWORD
unset APP_REDIS_PASSWORD
