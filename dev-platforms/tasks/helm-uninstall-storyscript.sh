#!/bin/bash

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
kubeconfig_dir="${workspace_dir}/kubeconfig"

account_file=${workspace_dir}/account.json

cat > ${account_file} <<EOF
${GCP_CREDENTIALS_JSON}
EOF

export GOOGLE_APPLICATION_CREDENTIALS=${account_file}
export KUBECONFIG=${kubeconfig_dir}/kubeconfig.yml

helm uninstall storyscript --debug
