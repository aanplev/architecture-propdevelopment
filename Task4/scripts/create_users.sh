#!/bin/bash
set -e

CERTS_DIR="../certs"
mkdir -p "$CERTS_DIR"

declare -A USERS=(
    ["devops"]="cluster-admin"
    ["techlead"]="namespace-admin"
    ["developer"]="edit"
    ["qa"]="view"
    ["security"]="audit-reader"
    ["infra"]="integration-read-only"
    ["smarthome"]="smart-home-gateway-editor"
)

for user in "${!USERS[@]}"; do
    openssl genrsa -out "$CERTS_DIR/$user.key" 2048
    openssl req -new -key "$CERTS_DIR/$user.key" -out "$CERTS_DIR/$user.csr" -subj "/CN=$user"
    openssl x509 -req -in "$CERTS_DIR/$user.csr" -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out "$CERTS_DIR/$user.crt" -days 365
done