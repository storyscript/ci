#!/bin/ash

# ENV
: "${WEBMASTER_EMAIL:="steve@storyscript.com"}"
: "${GCP_CREDENTIALS_JSON:?}"
: "${DOMAINS:="
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
*.vondel.storyscriptapp-ci.com,
storyscript-ci.com,
storyscriptapp-ci.com
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
  domains_list=$(echo $DOMAINS | awk '{split($0, domains, ","); for (i in domains) printf "-d%s ", domains[i]}')
  certbot certonly --dns-google $domains_list --non-interactive --agree-tos -m "${WEBMASTER_EMAIL}" --dns-google-credentials "${account_file}"
)
