#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

MARIADB_UID=$(oc get ns ${NS_MARIADB} -o custom-columns=UID:.metadata.annotations.'openshift\.io/sa\.scc\.uid-range' --no-headers | awk -F / '{ print $1 }')
MARIADB_GID=$(oc get ns ${NS_MARIADB} -o custom-columns=GID:.metadata.annotations.'openshift\.io/sa\.scc\.supplemental-groups' --no-headers | awk -F / '{ print $1 }')

export MARIADB_UID MARIADB_GID

oc create secret generic ${SECRET_MARIADB} -n ${NS_MARIADB} \
   --from-literal=mariadb-root-password="${MARIADB_ROOT_PASSWORD}" \
   --from-literal=mariadb-replication-password="${MARIADB_REPLICATION_PASSWORD}" \
   --from-literal=mariadb-password="${WP_DB_PASSWORD}" \
   --dry-run=client -o yaml --save-config |\
     oc apply -f -

envsubst < values-mariadb.yaml |\
  helm upgrade --install -n ${NS_MARIADB} -f - ${MARIADB_HELM_RELEASE} "$dirname/charts/mariadb"
