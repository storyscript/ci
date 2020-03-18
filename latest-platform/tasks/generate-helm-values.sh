#!/bin/bash

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
terraform_dir="${workspace_dir}/latest-tf-infrastructure"
tls_certs_dir="${workspace_dir}/tls-certs"

# OUTPUTS
helm_dir="${workspace_dir}/helmconfig"

name=$(cat "${terraform_dir}/name")

lb_ip="$(jq -r .load_balancer_ip < "${terraform_dir}/metadata")"
router_ip="$(jq -r .router_ip < "${terraform_dir}/metadata")"
db_ip="$(jq -r .database_ip < "${terraform_dir}/metadata")"

cat > "${helm_dir}/values.yml" <<EOF
domain: ${name}.${DOMAIN}
appsDomain: ${name}.${APPS_DOMAIN}

router:
  image: storyscript/router:latest
  loadBalancerIP: ${router_ip}

runtime:
  image: storyscript/runtime:latest

worker:
  image: storyscript/worker:latest

http:
  image: storyscript/http:latest

schema:
  image: storyscript/schema:latest

studio:
  image: storyscript/studio:latest

graphql:
  image: storyscript/graphql:latest

sls:
  image: storyscript/sls:latest

postgresql:
  create: false
  postgresqlHost: ${db_ip}
  postgresqlUsername: storyscript
  postgresqlPassword: storyscript

nginx-ingress:
  controller:
    service:
      loadBalancerIP: ${lb_ip}

auth:
  image: storyscript/auth:latest
  github:
    client_id: ${GITHUB_CLIENT_ID}
    client_secret: ${GITHUB_CLIENT_SECRET}

tls:
  enabled: true
  fullchain: |
$(awk '{printf "      %s\n", $0}' < ${tls_certs_dir}/fullchain.pem)
  privkey: |
$(awk '{printf "      %s\n", $0}' < ${tls_certs_dir}/privkey.pem)
EOF
