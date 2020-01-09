#!/bin/bash

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
terraform_dir="${workspace_dir}/terraform"
helm_dir="${workspace_dir}/helmconfig"
github_app_dir="${workspace_dir}/github-apps-pool"

name=$(cat "${terraform_dir}/name")

lb_ip="$(jq -r .load_balancer_ip < "${terraform_dir}/metadata")"

client_id="$(jq -r .client_id < "${github_app_dir}/metadata")"
client_secret="$(jq -r .client_secret < "${github_app_dir}/metadata")"

cat > "${helm_dir}/values.yml" <<EOF
domain: ${name}.${DOMAIN}

nginx-ingress:
  controller:
    service:
      loadBalancerIP: ${lb_ip}

auth:
  github:
    client_id: ${client_id}
    client_secret: ${client_secret}
EOF
