#!/bin/bash

set -Eeuo pipefail

# INPUTS
workspace_dir=$(pwd)
broken_pool_dir="${workspace_dir}/broken-pool"

name=$(cat "${broken_pool_dir}/name")

account_file=${workspace_dir}/account.json

cat > "${account_file}" <<EOF
${GCP_CREDENTIALS_JSON}
EOF

gcloud auth activate-service-account --key-file="${account_file}"

gcloud secrets list --filter="labels.env:${name}" --format="json" | jq ".[] | .name" | \
xargs -I secret_name gcloud secrets delete secret_name --quiet
