#!/bin/bash

set -Eeuo pipefail

# ENV
: "${TRIGGER_NAME:?}"
: "${GIT_USERNAME:="Storyscript CI"}"
: "${GIT_EMAIL:="ci@storyscript.io"}"

# INPUTS
workspace_dir=$(pwd)
pool_dir="${workspace_dir}/env-pool"

# OUTPUTS
output_dir="${workspace_dir}/updated-env-pool"

git clone "${pool_dir}" "${output_dir}"

pushd "${output_dir}" > /dev/null
  date +%s > "${TRIGGER_NAME}"
  git config user.name "${GIT_USERNAME}"
  git config user.email "${GIT_EMAIL}"
  git add "${TRIGGER_NAME}"
  git commit -m "Updating ${TRIGGER_NAME}"
popd > /dev/null
