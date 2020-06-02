#!/bin/ash

set -euxo pipefail

# ENV
: "${SITE_ID:?}"
: "${NETLIFY_AUTH_TOKEN:?}"

# INPUTS
workspace_dir=$(pwd)
tls_cert_dir="${workspace_dir}/tls-cert"

(cd "$tls_cert_dir" &&
  http POST "https://api.netlify.com/api/v1/sites/${SITE_ID}/ssl" \
    Authorization:"Bearer ${NETLIFY_AUTH_TOKEN}" \
    certificate=="$(cat fullchain.pem)" \
    key=="$(cat privkey.pem)"
)
