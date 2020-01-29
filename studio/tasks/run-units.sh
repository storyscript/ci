#!/bin/bash

set -eu

# INPUTS
workspace_dir="$(pwd)"
studio_dir="${workspace_dir}/studio"

pushd "${studio_dir}" > /dev/null
  yarn
  yarn lint
  yarn test:unit
popd > /dev/null
