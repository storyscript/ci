#!/bin/ash

set -euxo pipefail

# INPUTS
workspace_dir=$(pwd)
tls_cert_dir="${workspace_dir}/tls-cert"

(cd "$tls_cert_dir" &&
  cat ./fullchain.pem
  cat ./privkey.pem
)
