#!/bin/bash

# INPUTS
workspace_dir=$(pwd)
kubeconfig_dir="${workspace_dir}/kubeconfig"
helm_dir="${workspace_dir}/helmconfig"
chart_source="${workspace_dir}/storyscript-chart"

account_file=${workspace_dir}/account.json

cat > "${account_file}" <<EOF
${GCP_CREDENTIALS_JSON}
EOF

export GOOGLE_APPLICATION_CREDENTIALS=${account_file}
export KUBECONFIG=${kubeconfig_dir}/kubeconfig.yml

if [ -d "${chart_source}" ];
then
  helm upgrade --install storyscript "${chart_source}" -f "${helm_dir}/values.yml" --debug --recreate-pods
else
  helm repo add storyscript https://storyscript.github.io/storyscript-chart
  helm upgrade --install storyscript storyscript/storyscript -f "${helm_dir}/values.yml" --debug --recreate-pods
fi
