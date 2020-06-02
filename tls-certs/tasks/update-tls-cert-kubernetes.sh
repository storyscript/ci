#!/bin/bash

set -Eeuxo pipefail

# ENV
: "${GCP_CREDENTIALS_JSON:?}"

# INPUTS
workspace_dir=$(pwd)
tls_cert_dir="${workspace_dir}/tls-cert"

account_file=${workspace_dir}/account.json
cat > "${account_file}" <<EOF
${GCP_CREDENTIALS_JSON}
EOF

gcloud auth activate-service-account --key-file="${account_file}"
gcloud container clusters get-credentials production --region europe-west4 --project storyscript

pushd "${tls_cert_dir}" > /dev/null
  kubectl create secret tls storyscript-tls-cert \
    --key ./privkey.pem \
    --cert ./fullchain.pem \
    -o yaml \
    --dry-run=client | kubectl replace -f -
popd > /dev/null
