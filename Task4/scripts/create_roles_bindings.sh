#!/bin/bash

RBAC_DIR="./rbac"

if [ ! -d "$RBAC_DIR" ]; then
  echo "Папка $RBAC_DIR не найдена"
  exit 1
fi

kubectl apply -f "$RBAC_DIR"
