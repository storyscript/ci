#!/bin/ash

set -euo pipefail

# ENV
: "${WEBMASTER_EMAIL:="steve@storyscript.io"}"
: "${GCP_CREDENTIALS_JSON:?}"
: "${DOMAINS:="
storyscript-ci.com,
storyscriptapp-ci.com,
beatrix.storyscript-ci.com,
*.beatrix.storyscript-ci.com,
*.beatrix.storyscriptapp-ci.com,
ooster.storyscript-ci.com,
*.ooster.storyscript-ci.com,
*.ooster.storyscriptapp-ci.com,
rembrandt.storyscript-ci.com,
*.rembrandt.storyscript-ci.com,
*.rembrandt.storyscriptapp-ci.com,
sarphati.storyscript-ci.com,
*.sarphati.storyscript-ci.com,
*.sarphati.storyscriptapp-ci.com,
sloter.storyscript-ci.com,
*.sloter.storyscript-ci.com,
*.sloter.storyscriptapp-ci.com,
vondel.storyscript-ci.com,
*.vondel.storyscript-ci.com,
*.vondel.storyscriptapp-ci.com
"}"


# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
output_dir="${workspace_dir}/tls-certs"


account_file=${workspace_dir}/account.json

cat > "${account_file}" <<EOF
${GCP_CREDENTIALS_JSON}
EOF

(cd "$output_dir" &&
  domains_list=$(echo $DOMAINS | awk '{split($0, domains, ","); for (i=1; i<=length(domains); i++) printf "-d %s ", domains[i]}')
  certbot certonly $domains_list --dns-google --dns-google-credentials "${account_file}" -m "${WEBMASTER_EMAIL}" --non-interactive --agree-tos
  cp -Lr /etc/letsencrypt/live/* .
)
