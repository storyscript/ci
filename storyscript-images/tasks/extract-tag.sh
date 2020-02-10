#!/bin/bash

set -Eeuo pipefail

# INPUTS
workspace_dir="$(pwd)"
repo_dir="${workspace_dir}/repo"

# OUTPUTS
tag_dir="${workspace_dir}/tag"

pushd "${repo_dir}" > /dev/null
  tag=$(git tag --points-at HEAD)
  [ -n "$tag" ] || tag="latest"
  echo $tag > "${tag_dir}/tag"
popd > /dev/null
