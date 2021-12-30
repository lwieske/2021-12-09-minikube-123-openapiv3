#!/usr/bin/env bash

minikube start \
    --kubernetes-version=v1.23.0 \
    --container-runtime=containerd \
    --feature-gates=OpenAPIV3=true \
    --driver=hyperkit

sleep 60

export CLUSTER_NAME="minikube"
export APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")
export TOKEN=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)

set +x
echo "################################################################################"
echo "### get API /api"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/api \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### get API /api/v1"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/api/v1 \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### get API /api/v2"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/api/v2 \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### get API /openapi/v2"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/openapi/v2 \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### GET /openapi/v3"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/openapi/v3 \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### GET .../events.k8s.io"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/openapi/v3/apis/events.k8s.io \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### GET .../events.k8s.io/v1"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/openapi/v3/apis/events.k8s.io/v1 \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20

set +x
echo "################################################################################"
echo "### GET .../events.k8s.io/v1beta1"
echo "################################################################################"
set -x

sleep 20

curl --silent \
    --request GET $APISERVER/openapi/v3/apis/events.k8s.io/v1beta1 \
    --header "Authorization: Bearer $TOKEN" \
    --insecure | \
jq .  | \
head -20

sleep 20
