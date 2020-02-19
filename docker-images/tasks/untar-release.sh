#!/bin/bash

set -Eeuo pipefail

# INPUTS
workspace_dir="$(pwd)"
release_dir="${workspace_dir}/release"

pushd "${release_dir}" > /dev/null
  tar -xf source.tar.gz --one-top-level
  pushd "source" > /dev/null
    mv */* .
  popd > /dev/null
popd > /dev/null
