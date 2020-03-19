#!/bin/bash

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
terraform_dir="${workspace_dir}/platform-terraform"

# OUTPUTS
kubeconfig_dir="${workspace_dir}/kubeconfig"

name=$(cat "${terraform_dir}/name")
kube_ip="$(jq -r .cluster_endpoint < "${terraform_dir}/metadata")"
ca_cert="$(jq -r .cluster_ca_certificate < "${terraform_dir}/metadata" | base64 -w 0)"

cat > "${kubeconfig_dir}/kubeconfig.yml" <<EOF
apiVersion: v1
kind: Config
current-context: ${name}
contexts: [{name: ${name}, context: {cluster: ${name}, user: ${name}}}]
users: [{name: $name, user: {auth-provider: {name: gcp}}}]
clusters:
- name: ${name}
  cluster:
    server: https://${kube_ip}
    certificate-authority-data: ${ca_cert}
EOF
