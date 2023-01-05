#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

envsubst < route.yaml |\
  oc apply -f -
