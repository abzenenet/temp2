#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

envsubst < sc.yaml |\
  oc apply -f -
