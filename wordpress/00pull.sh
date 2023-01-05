#!/bin/bash

script=$(readlink -f "$0")
dirname=$(dirname "$script")

. "$dirname/env.sh"

skopeo copy --all \
  docker://$MARIADB_SRC_REGISTRY/$MARIADB_SRC_REPO:$MARIADB_TAG \
  docker://$LOCAL_REGISTRY/$MARIADB_TARGET_REPO:$MARIADB_TAG
skopeo copy --all \
  docker://$WORDPRESS_SRC_REGISTRY/$WORDPRESS_SRC_REPO:$WORDPRESS_TAG \
  docker://$LOCAL_REGISTRY/$WORDPRESS_TARGET_REPO:$WORDPRESS_TAG

helm repo add bitnami https://charts.bitnami.com/bitnami
mkdir -p "$dirname/charts"
helm pull bitnami/mariadb --version ${MARIADB_HELM_VERSION} -d "$dirname/charts" --untar
helm pull bitnami/wordpress --version ${WORDPRESS_HELM_VERSION} -d "$dirname/charts" --untar
