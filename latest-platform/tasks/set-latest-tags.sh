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
  image:
    tag: latest

creds:
  image:
    tag: latest

geh:
  image:
    tag: latest

graphql:
  image:
    tag: latest

http:
  image:
    tag: latest

compiler:
  image:
    tag: latest

router:
  image:
    tag: latest

runtime:
  image:
    tag: latest

schema:
  image:
    tag: latest

sls:
  image:
    tag: latest

studio:
  image:
    tag: latest

worker:
  image:
    tag: latest
EOF

yq merge "${helmconfig_dir}/values.yml" "${latest_tags_file}" > "${latest_helmconfig_dir}/values.yml"
