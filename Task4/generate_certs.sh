#!/bin/bash

set -euo pipefail

CERTS_DIR="./certs"
mkdir -p "${CERTS_DIR}"

CA_CERT="${HOME}/.minikube/ca.crt"
CA_KEY="${HOME}/.minikube/ca.key"

USERS=(
  devops
  qa
  techlead
  smarthome
  infra
  security
  developer
)

for user in "${USERS[@]}"; do
  echo "Generating cert for user: $user"

  openssl genrsa -out "${CERTS_DIR}/${user}.key" 2048

  openssl req -new -key "${CERTS_DIR}/${user}.key" -out "${CERTS_DIR}/${user}.csr" -subj "/CN=${user}/O=${user}"

  openssl x509 -req -in "${CERTS_DIR}/${user}.csr" -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
    -out "${CERTS_DIR}/${user}.crt" -days 365

  echo "Generated cert for ${user}"
done
