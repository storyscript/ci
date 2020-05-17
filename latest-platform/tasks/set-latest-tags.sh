#!/bin/ash

set -eu

# INPUTS
workspace_dir=$(pwd)
helmconfig_dir="${workspace_dir}/helmconfig"

# OUTPUTS
latest_helmconfig_dir="${workspace_dir}/latest-helmconfig"

latest_tags_file="latest_tags.yml"

cat > "${latest_tags_file}" <<EOF
auth:
  image: storyscript/auth:latest

compiler:
  image: storyscript/language:latest

creds:
  image: storyscript/creds:latest

geh:
  image: storyscript/geh:latest

graphql:
  image: storyscript/graphql:latest

http:
  image: storyscript/http:latest

router:
  image: storyscript/router:latest

runtime:
  image: storyscript/runtime:latest

schema:
  image: storyscript/schema:latest

sls:
  image: storyscript/sls:latest

studio:
  image: storyscript/studio:latest

worker:
  image: storyscript/worker:latest
EOF

yq merge "${helmconfig_dir}/values.yml" "${latest_tags_file}" > "${latest_helmconfig_dir}/values.yml"
