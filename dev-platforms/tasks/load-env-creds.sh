#!/bin/bash

set -Eeuo pipefail

# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
output_dir="${workspace_dir}/env-creds"

account_file=${workspace_dir}/account.json

cat > "${account_file}" <<EOF
${GCP_CREDENTIALS_JSON}
EOF

gcloud auth activate-service-account --key-file="${account_file}"

pushd "${output_dir}" > /dev/null
  gcloud secrets list --filter="labels.type:env-creds" --format="value(name)" | while read -r secret_name; do
    env_name=${secret_name##*_} # "##pattern" => delete longest match of pattern from the beginning
    gcloud secrets versions access latest --secret="$secret_name" > "${env_name}".json
  done
popd > /dev/null
