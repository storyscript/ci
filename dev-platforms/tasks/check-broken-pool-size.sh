#!/bin/bash

set -eu

# ENV
: "${POOL_NAME:="broken-dev-platforms"}"
: "${GIT_USERNAME:="Storyscript CI"}"
: "${GIT_EMAIL:="ci@storyscript.io"}"

# INPUTS
workspace_dir=$(pwd)
pool_dir="${workspace_dir}/env-pool"
exit_code=1

pushd "${pool_dir}" > /dev/null
  echo "Searching for dev-platforms..."

  count="$(find "${POOL_NAME}/unclaimed" -not -path '*/\.*' -type f | wc -l)"
  echo "Broken dev-platforms: ${count}"

  if [ "${count}" -gt "0" ]; then
    echo "At least one broken dev platform exists"
    exit_code=0
  fi
popd > /dev/null

echo "DONE"
exit $exit_code
