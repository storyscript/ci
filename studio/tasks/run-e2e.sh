#!/bin/bash

set -eu

# INPUTS
workspace_dir="$(pwd)"
studio_dir="${workspace_dir}/studio"
env_dir="${workspace_dir}/env"

env_name=$(cat "${env_dir}/name")
export TEST_URL="https://studio.${env_name}.storyscript-ci.com"

pushd "${studio_dir}" > /dev/null
  yarn
  yarn test:integration-headless
popd > /dev/null
