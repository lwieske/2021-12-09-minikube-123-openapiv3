---
marp: true
---

<!-- _class: invert -->

## Kubernetes

* Kubernetes, also known as K8s, is an open-source system for automating
  deployment, scaling, and management of containerized applications.

* It groups containers that make up an application into logical units for easy
  management and discovery. Kubernetes builds upon 15 years of experience of
  running production workloads at Google, combined with best-of-breed ideas and
  practices from the community.

---

## Kubernetes Architecture

* A Kubernetes cluster consists of a set of executor machines, called nodes,
  that run containerized applications. Every cluster has at least one executor
  node.

* The executor node(s) host the Pods that are the components of the application
  workload. The control plane manages the executor nodes and the Pods in the
  cluster. In production environments, the control plane usually runs across
  multiple computers and a cluster usually runs multiple nodes, providing
  fault-tolerance and high availability.

---

![](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

---

## Kubernetes Communication

* Kubernetes has a "hub-and-spoke" API pattern. All API usage from nodes (or the
  pods they run) terminates at the apiserver. None of the other control plane
  components are designed to expose remote services. The apiserver is configured
  to listen for remote connections on a secure HTTPS port (typically 443) with
  one or more forms of client authentication enabled. One or more forms of
  authorization should be enabled, especially if anonymous requests or service
  account tokens are allowed.

---

## Kubernetes API

* The core of Kubernetes' control plane is the API server. The API server
  exposes an HTTP API that lets end users, different parts of your cluster, and
  external components communicate with one another.

* The Kubernetes API lets you query and manipulate the state of API objects in
  Kubernetes (for example: Pods, Namespaces, ConfigMaps, and Events).

* Most operations can be performed through the kubectl command-line interface or
  other command-line tools, such as kubeadm, which in turn use the API. However,
  you can also access the API directly using REST calls.

---

## OpenAPI Specification

### OpenAPI V2

* The Kubernetes API server serves an aggregated OpenAPI v2 spec via the
  */openapi/v2* endpoint. Request options are:

* Kubernetes implements an alternative Protobuf based serialization format that
  is primarily intended for intra-cluster communication.

---

## OpenAPI Specification (II)

### OpenAPI V3

FEATURE STATE: Kubernetes v1.23 [alpha]

* Kubernetes v1.23 offers initial support for publishing its APIs as OpenAPI v3;
  this is an alpha feature that is disabled by default. You can enable the alpha
  feature by turning on the feature gate named OpenAPIV3 for the kube-apiserver
  component.

* With the feature enabled, the Kubernetes API server serves an aggregated
  OpenAPI v3 spec per Kubernetes group version at the
  */openapi/v3/apis/<group>/<version>* endpoint.

---

## Minikube

* Minikube is local Kubernetes, focusing on making it easy to learn and develop
  for Kubernetes.

* It allows for quick access to new versions and feature gates by building upon
  *kubeadm*.

* What you’ll need

  * 2 CPUs or more
  * 2GB of free memory
  * 20GB of free disk space
  * Internet connection
  * Container or virtual machine manager, such as: Docker, Hyperkit, Hyper-V,
    KVM, Parallels, Podman, VirtualBox, or VMware Fusion/Workstation

---

## Starting Minikube

```
minikube start \
  --kubernetes-version=v1.23.0 \
  --container-runtime=containerd \
  --feature-gates=OpenAPIV3=true \
  --driver=hyperkit
😄  minikube v1.24.0 auf Darwin 12.0.1
✨  Using the hyperkit driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🔥  Creating hyperkit VM (CPUs=2, Memory=4000MB, Disk=20000MB) ...
📦  Vorbereiten von Kubernetes v1.23.0 auf containerd 1.4.9...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

---

## Getting APISERVER And TOKEN

* APISERVER

```
kubectl config view \
  -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}"
```

* TOKEN

```
kubectl get secrets \
  -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}" | \
  base64 --decode
```

---

## GET /api

```
curl -X GET <<<APISERVER>>>/api --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```


```
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "192.168.64.6:8443"
    }
  ]
}
```

---

## GET /api/v1

```
curl -X GET <<<APISERVER>>>/api/v1 --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "componentstatuses",
      "singularName": "",
      "namespaced": false,
      "kind": "ComponentStatus",
      "verbs": [
        "get",
... to be continued ...
```

---

## GET /api/v2

```
curl -X GET <<<APISERVER>>>/api/v2 --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "the server could not find the requested resource",
  "reason": "NotFound",
  "details": {},
  "code": 404
}
```

---

## GET /openapi/v2

```
curl -X GET <<<APISERVER>>>/openapi/v2 --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "swagger": "2.0",
  "info": {
    "title": "Kubernetes",
    "version": "v1.23.0"
  },
  "paths": {
    "/.well-known/openid-configuration/": {
      "get": {
        "description": "get service account issuer OpenID configuration, also known as the 'OIDC discovery doc'",
        "produces": [
          "application/json"
        ],
        "schemes": [
          "https"
        ],
        "tags": [
          "WellKnown"
        ],
        "operationId": "getServiceAccountIssuerOpenIDConfiguration",
... to be continued ...
```

---
### GET /openapi/v3

```
curl -X GET <<<APISERVER>>>/openapi/v3 --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "Paths": [
    ".well-known/openid-configuration",
    "api",
    "api/v1",
    "apis",
    ... lines intentionally deleted ...
    "apis/authentication.k8s.io",
    "apis/authentication.k8s.io/v1",
    "apis/authorization.k8s.io",
    "apis/authorization.k8s.io/v1",
    "apis/autoscaling",
    "apis/autoscaling/v1",
    "apis/autoscaling/v2",
    "apis/autoscaling/v2beta1",
... to be continued ...
```

* That's new in K8S v1.23.0. OpenAPIV3 feature gate alpha

---

## GET .../events.k8s.io

```
curl -X GET <<<APISERVER>>>/openapi/v3/apis/events.k8s.io --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "openapi": "3.0.0",
  "info": {
    "title": "Kubernetes",
    "version": "v1.23.0"
  },
  "paths": {
    "/apis/events.k8s.io/": {
      "get": {
        "tags": [
          "events"
        ],
        "description": "get information of a group",
        "operationId": "getEventsAPIGroup",
        "responses": {
          "200": {
... to be continued ...
```

---

### GET .../events.k8s.io/v1

```
curl -X GET <<<APISERVER>>>/openapi/v3/apis/events.k8s.io/v1 --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "openapi": "3.0.0",
  "info": {
    "title": "Kubernetes",
    "version": "v1.23.0"
  },
  "paths": {
    "/apis/events.k8s.io/v1/": {
      "get": {
        "tags": [
          "events_v1"
        ],
        "description": "get available resources",
        "operationId": "getEventsV1APIResources",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
... to be continued ...
```

---

## GET .../events.k8s.io/v1beta1

```
curl -X GET <<<APISERVER>>>/openapi/v3/apis/events.k8s.io/v1beta1 --header 'Authorization: Bearer <<<TOKEN>>>' --insecure | jq .
```

```
{
  "openapi": "3.0.0",
  "info": {
    "title": "Kubernetes",
    "version": "v1.23.0"
  },
  "paths": {
    "/apis/events.k8s.io/v1beta1/": {
      "get": {
        "tags": [
          "events_v1beta1"
        ],
        "description": "get available resources",
        "operationId": "getEventsV1beta1APIResources",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
... to be continued ...
```

---

<!-- _class: invert -->

## Script

* Start Minikube, get ip/port of the api-server and the token to access it

* GET /api

* GET /api/v1

* GET /api/v2

* GET /openapi/v2

* GET /openapi/v3

* GET .../events.k8s.io

* GET .../events.k8s.io/v1

* GET .../events.k8s.io/v1beta1
