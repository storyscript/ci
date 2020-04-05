#!/bin/bash

set -Eeuo pipefail

workspace_dir=$(pwd)

# shellcheck disable=SC2154
env=$(cat "${ENV_NAME_FILE}")

account_file=${workspace_dir}/account.json

cat > "${account_file}" <<EOF
${GCP_CREDENTIALS_JSON}
EOF

gcloud auth activate-service-account --key-file="${account_file}"

gcloud secrets list --filter="labels.env:${env}" --format="json" | jq ".[] | .name" | \
xargs -I secret_name gcloud secrets delete secret_name --quiet
