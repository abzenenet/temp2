#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

WORDPRESS_UID=$(oc get ns ${NS_WORDPRESS} -o custom-columns=UID:.metadata.annotations.'openshift\.io/sa\.scc\.uid-range' --no-headers | awk -F / '{ print $1 }')
WORDPRESS_GID=$(oc get ns ${NS_WORDPRESS} -o custom-columns=GID:.metadata.annotations.'openshift\.io/sa\.scc\.supplemental-groups' --no-headers | awk -F / '{ print $1 }')

export WORDPRESS_UID WORDPRESS_GID

oc create secret generic ${SECRET_WORDPRESS} -n ${NS_WORDPRESS} \
   --from-literal=wordpress-password="${WP_PASSWORD}" \
   --from-literal=mariadb-password="${WP_DB_PASSWORD}" \
   --dry-run=client -o yaml --save-config |\
     oc apply -f -

envsubst < values-wordpress.yaml |\
  helm upgrade --install -n ${NS_WORDPRESS} -f - ${WORDPRESS_HELM_RELEASE} "$dirname/charts/wordpress"
