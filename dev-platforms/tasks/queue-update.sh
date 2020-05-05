#!/bin/bash

set -eu

# ENV
: "${GIT_USERNAME:="Storyscript CI"}"
: "${GIT_EMAIL:="ci@storyscript.io"}"

# INPUTS
workspace_dir=$(pwd)
pool_dir="${workspace_dir}/env-pool"

# OUTPUTS
output_dir="${workspace_dir}/updated-env-pool"

git clone "${pool_dir}" "${output_dir}"

pushd "${output_dir}" > /dev/null
  unclaimed_count="$(find dev-platforms/unclaimed -not -path '*/\.*' -type f | wc -l)"
  echo "Unclaimed dev-platforms: ${unclaimed_count}"
  if [ "${unclaimed_count}" -gt 0 ]; then
    git config user.name "${GIT_USERNAME}"
    git config user.email "${GIT_EMAIL}"
    git mv dev-platforms/unclaimed/* updating-dev-platforms/unclaimed/
    git commit -m "Move ${unclaimed_count} unclaimed dev-platforms to updating-dev-platforms"
  fi
popd > /dev/null

echo "DONE"
