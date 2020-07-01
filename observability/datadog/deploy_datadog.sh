#!/usr/bin/env bash

set -euo pipefail

[ -z "$DATADOG_API_KEY" ] && echo "DATADOG_API_KEY unset"

helm3 upgrade --install -f datadog-agent.yaml \
--namespace=monitoring \
--set datadog.processAgent.enabled=true \
--set datadog.processAgent.processCollection=true \
--set datadog.site='datadoghq.eu' \
--set datadog.apiKey=${DATADOG_API_KEY} \
datadog-agent stable/datadog
