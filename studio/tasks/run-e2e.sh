#!/bin/sh

set -eu

# INPUTS
workspace_dir="$(pwd)"
studio_dir="${workspace_dir}/studio"

cd "${studio_dir}"

export TEST_URL=https://studio.beatrix.storyscript-ci.com
export WITH_NETLIFY=false
export WITH_INTERCOM=false
yarn
yarn test:integration-headless

cd "${workspace_dir}"
