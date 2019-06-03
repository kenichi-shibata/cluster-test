#!/usr/bin/env bash

set -euo pipefail

helm init --history-max 200 --service-account tiller
