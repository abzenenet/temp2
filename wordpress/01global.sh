#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

oc get scc restricted -o yaml |\
  egrep -v 'generation:|creationTimestamp:|resourceVersion:|uid:' |\
  sed -e 's#name: restricted#name: restricted-seccomp#' -e '$aseccompProfiles:' -e '$a- runtime/default' |\
  oc apply -f -

oc new-project ${NS_MARIADB}
oc new-project ${NS_WORDPRESS}
oc adm policy add-scc-to-user restricted-seccomp system:serviceaccount:${NS_WORDPRESS}:${SA_WORDPRESS}
