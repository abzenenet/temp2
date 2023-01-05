#LOCAL_REGISTRY=

if [ -z "$LOCAL_REGISTRY" ]; then
  registry=$(host registry)
  if [ $? -gt 0 ]; then
    echo "$registry"
    exit 1
  fi
  LOCAL_REGISTRY=$(echo $registry | awk '{ print $1 }')
fi

MARIADB_SRC_REGISTRY=docker.io
MARIADB_SRC_REPO=bitnami/mariadb
MARIADB_TARGET_REPO=bitnami/mariadb
MARIADB_TAG=10.6.11-debian-11-r12
MARIADB_HELM_VERSION=11.4.2
MARIADB_HELM_RELEASE=mariadb

WORDPRESS_SRC_REGISTRY=docker.io
WORDPRESS_SRC_REPO=bitnami/wordpress
WORDPRESS_TARGET_REPO=bitnami/wordpress
WORDPRESS_TAG=6.1.1-debian-11-r15
WORDPRESS_HELM_VERSION=15.2.22
WORDPRESS_HELM_RELEASE=wordpress

CLUSTER_WILDCARD_DOMAIN=$(oc get ingresses.config.openshift.io cluster  -o jsonpath='{.spec.domain}')
WORDPRESS_DOMAIN="wordpress.$CLUSTER_WILDCARD_DOMAIN"

MARIADB_ROOT_PASSWORD="Admin123."
MARIADB_REPLICATION_PASSWORD="Repl123."

WP_DB_NAME="wordpress"
WP_DB_USER="wordpress"
WP_DB_PASSWORD="Pass123."

WP_USERNAME="wp"
WP_PASSWORD="WordPress123."

SC_WORDPRESS=wordpress
SA_WORDPRESS=wordpress
NS_MARIADB=mariadb
NS_WORDPRESS=wordpress
SECRET_MARIADB=wordpress-mariadb-passwords
SECRET_WORDPRESS=wordpress-passwords
SVC_MARIADB=mariadb
SVC_WORDPRESS=wordpress
ROUTE_WORDPRESS=wordpress

export LOCAL_REGISTRY MARIADB_TARGET_REPO MARIADB_TAG WORDPRESS_TARGET_REPO WORDPRESS_TAG WORDPRESS_DOMAIN
export MARIADB_HELM_VERSION MARIADB_HELM_RELEASE WORDPRESS_HELM_VERSION WORDPRESS_HELM_RELEASE
export MARIADB_ROOT_PASSWORD MARIADB_REPLICATION_PASSWORD WP_DB_NAME WP_DB_USER WP_DB_PASSWORD WP_USERNAME WP_PASSWORD
export SC_WORDPRESS SA_WORDPRESS NS_MARIADB NS_WORDPRESS SECRET_MARIADB SECRET_WORDPRESS
export SVC_MARIADB SVC_WORDPRESS ROUTE_WORDPRESS
