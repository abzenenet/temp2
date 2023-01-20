#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

podname=$(oc get -n wordpress pod -l app.kubernetes.io/instance=wordpress -o jsonpath='{.items[0].metadata.name}')

oc cp "$dirname/nonce.php" \
  "wordpress/$podname":/opt/bitnami/wordpress/wp-admin/nonce.php
