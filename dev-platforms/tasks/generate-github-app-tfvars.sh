#!/bin/bash

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
terraform_dir="${workspace_dir}/platform-terraform"

# OUTPUTS
tfvars_dir="${workspace_dir}/tfvars"

platform_name=$(cat "${terraform_dir}/name")

cat > "${tfvars_dir}/app.tfvars" <<EOF
platform_name = "${platform_name}"
EOF
