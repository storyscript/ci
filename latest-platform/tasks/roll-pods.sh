#!/bin/bash

# INPUTS
workspace_dir=$(pwd)
kubeconfig_dir="${workspace_dir}/kubeconfig"

account_file=${workspace_dir}/account.json

cat > ${account_file} <<EOF
${GCP_CREDENTIALS_JSON}
EOF

export GOOGLE_APPLICATION_CREDENTIALS=${account_file}
export KUBECONFIG=${kubeconfig_dir}/kubeconfig.yml

version=$(helm list -o json | jq -r ".[].chart" | grep -o '[^-]*$')

helm repo add storyscript https://storyscript.github.io/storyscript-chart
helm upgrade storyscript storyscript/storyscript --version "$version" --recreate-pods --reuse-values --debug
