#!/bin/bash

set -eu

# ENV
: "${MIN_UNCLAIMED_COUNT:?}"
: "${POOL_NAME:="dev-platforms"}"
: "${BUILDING_POOL_NAME:="building-dev-platforms"}"
: "${GIT_USERNAME:="Storyscript CI"}"
: "${GIT_EMAIL:="ci@storyscript.io"}"

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
pool_dir="${workspace_dir}/env-pool"

# OUTPUTS
output_dir="${workspace_dir}/updated-env-pool"

git clone "${pool_dir}" "${output_dir}"

pushd "${output_dir}" > /dev/null
  echo "Searching for dev-platforms..."

  ready_count="$(find "${POOL_NAME}/unclaimed" -not -path '*/\.*' -type f | wc -l)"
  echo "Ready dev-platforms: ${ready_count}"
  building_count="$(find "${BUILDING_POOL_NAME}/claimed" -not -path '*/\.*' -type f | wc -l)"
  echo "Building dev-platforms: ${building_count}"

  env_count=$((ready_count + building_count))
  echo "Total count: ${env_count}"

  if [ "${env_count}" -lt "${MIN_UNCLAIMED_COUNT}" ]; then
    echo "Fewer than ${MIN_UNCLAIMED_COUNT} dev platforms, going to trigger creation"
    # The create-dev-platform job watches this file for changes
    date +%s > .trigger-dev-platforms-create

    git config user.name "${GIT_USERNAME}"
    git config user.email "${GIT_EMAIL}"
    git add .trigger-dev-platforms-create
    git commit -m "Not enough unclaimed envs in ${POOL_NAME} or ${BUILDING_POOL_NAME} pools, updating trigger."
  fi
popd > /dev/null

echo "DONE"
