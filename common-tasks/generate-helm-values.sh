#!/bin/bash

# INPUTS
workspace_dir=$(pwd)
terraform_dir="${workspace_dir}/platform-terraform"
apps_dir="${workspace_dir}/app-credentials"
tls_certs_dir="${workspace_dir}/tls-certs"

# OUTPUTS
helm_dir="${workspace_dir}/helmconfig"

name=$(cat "${terraform_dir}/name")

lb_ip="$(jq -r .load_balancer_ip < "${terraform_dir}/metadata")"
router_ip="$(jq -r .router_ip < "${terraform_dir}/metadata")"
db_ip="$(jq -r .database_ip < "${terraform_dir}/metadata")"

github_client_id="$(jq -r .github.client_id < "${apps_dir}/metadata")"
github_client_secret="$(jq -r .github.client_secret < "${apps_dir}/metadata")"

slack_client_id="$(jq -r .slack.client_id < "${apps_dir}/metadata")"
slack_client_secret="$(jq -r .slack.client_secret < "${apps_dir}/metadata")"
slack_signing_secret="$(jq -r .slack.signing_secret < "${apps_dir}/metadata")"

google_service_account_key="$(jq -r .service_account_key < "${terraform_dir}/metadata")"

cat > "${helm_dir}/values.yml" <<EOF
domain: ${name}.${DOMAIN}
appsDomain: ${name}.${APPS_DOMAIN}

geh:
  image: storyscript/geh:latest
  slack_signing_key: ${slack_signing_secret}

router:
  image: storyscript/router:latest
  loadBalancerIP: ${router_ip}

runtime:
  image: storyscript/runtime:latest
  wolfram_app_id: ${WOLFRAM_APP_ID}

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
    client_id: ${github_client_id}
    client_secret: ${github_client_secret}

tls:
  enabled: true
  fullchain: |
$(awk '{printf "      %s\n", $0}' < "${tls_certs_dir}"/fullchain.pem)
  privkey: |
$(awk '{printf "      %s\n", $0}' < "${tls_certs_dir}"/privkey.pem)

creds:
  gcp_secretmanager_key: |
    $(echo -n "${google_service_account_key}" | awk '{printf "      %s\n", $0}')
  github:
    client_id: ${github_client_id}
    client_secret: ${github_client_secret}
  slack:
    client_id: ${slack_client_id}
    client_secret: ${slack_client_secret}
EOF
