#!/bin/bash

set -e

CERT_DIR="./certs"
KUBECONFIG_DIR="./kubeconfigs"
CLUSTER_NAME="minikube"
API_SERVER=$(minikube ip):8443

mkdir -p "$KUBECONFIG_DIR"

declare -A USERS=(
  [devops]="cluster-admin"
  [qa]="view"
  [techlead]="namespace-admin"
  [smarthome]="smart-home-gateway-editor"
  [infra]="integration-read-only"
  [security]="audit-reader"
  [developer]="edit"
)

for user in "${!USERS[@]}"; do
  role="${USERS[$user]}"
  kubeconfig_path="${KUBECONFIG_DIR}/${user}.kubeconfig"

  kubectl config set-cluster "$CLUSTER_NAME" \
    --server="https://${API_SERVER}" \
    --certificate-authority="${HOME}/.minikube/ca.crt" \
    --embed-certs=true \
    --kubeconfig="${kubeconfig_path}"

  kubectl config set-credentials "$user" \
    --client-certificate="${CERT_DIR}/${user}.crt" \
    --client-key="${CERT_DIR}/${user}.key" \
    --embed-certs=true \
    --kubeconfig="${kubeconfig_path}"

  kubectl config set-context "${user}-context" \
    --cluster="$CLUSTER_NAME" \
    --user="$user" \
    --kubeconfig="${kubeconfig_path}"

  kubectl config use-context "${user}-context" --kubeconfig="${kubeconfig_path}"

  echo "Kubeconfig created for user $user with role $role"
done
