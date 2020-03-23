#!/usr/bin/env bash

# Run consul agent in development mode

consul agent -dev -enable-script-checks -config-dir=./

