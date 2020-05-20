#!/bin/bash

# INPUTS
workspace_dir=$(pwd)
terraform_dir="${workspace_dir}/platform-terraform"
env_creds_dir="${workspace_dir}/env-creds"
tls_certs_dir="${workspace_dir}/tls-certs"

# OUTPUTS
helm_dir="${workspace_dir}/helmconfig"

env_name=$(cat "${terraform_dir}/name")

lb_ip="$(jq -r .load_balancer_ip < "${terraform_dir}/metadata")"
router_ip="$(jq -r .router_ip < "${terraform_dir}/metadata")"
db_ip="$(jq -r .database_ip < "${terraform_dir}/metadata")"

github_app_id="$(jq -r .github.app_id < "${env_creds_dir}/${env_name}.json")"
github_app_private_key="$(jq -r .github.app_private_key < "${env_creds_dir}/${env_name}.json")"
github_client_id="$(jq -r .github.client_id < "${env_creds_dir}/${env_name}.json")"
github_client_secret="$(jq -r .github.client_secret < "${env_creds_dir}/${env_name}.json")"

slack_client_id="$(jq -r .slack.client_id < "${env_creds_dir}/${env_name}.json")"
slack_client_secret="$(jq -r .slack.client_secret < "${env_creds_dir}/${env_name}.json")"
slack_signing_secret="$(jq -r .slack.signing_secret < "${env_creds_dir}/${env_name}.json")"

google_service_account_key="$(jq -r .service_account_key < "${terraform_dir}/metadata")"

cat > "${helm_dir}/values.yml" <<EOF
domain: ${env_name}.${DOMAIN}
appsDomain: ${env_name}.${APPS_DOMAIN}

studio:
  integrations:
    intercom: ${INTERCOM_APP_ID}
    fullstory: ${FULLSTORY_ORG_ID}
  sentry:
    dsn: ${SENTRY_DSN}

geh:
  slack_signing_key: ${slack_signing_secret}

router:
  loadBalancerIP: ${router_ip}

runtime:
  wolfram_app_id: ${WOLFRAM_APP_ID}
  github:
    app_id: "${github_app_id}"
    app_private_key: |
$(echo -n "${github_app_private_key}" | awk '{printf "      %s\n", $0}')

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
    client_id: "${slack_client_id}"
    client_secret: ${slack_client_secret}
EOF
