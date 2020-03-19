#!/bin/bash

set -Eeuo pipefail

# INPUTS
workspace_dir=$(pwd)
release_dir="${workspace_dir}/release"

# OUTPUTS
tag_env_var_dir="${workspace_dir}/tag-env-var"

jq -n --arg tag "$(cat "${release_dir}/tag")" '{TAG: $tag}' > "${tag_env_var_dir}/tag-env-var.json"
