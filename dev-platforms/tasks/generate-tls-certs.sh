#!/bin/ash

# INPUTS
workspace_dir=$(pwd)
terraform_dir="${workspace_dir}/platform-terraform"

# OUTPUTS
tls_certs_dir="${workspace_dir}/tls-certs"

name=$(cat "${terraform_dir}/name")
account_file=${workspace_dir}/account.json

cat > ${account_file} <<EOF
${GCP_CREDENTIALS_JSON}
EOF

certbot certonly -n --agree-tos \
  --dns-google \
  --dns-google-credentials ${account_file} \
  -m "infra@storyscript.com" \
  -d "${name}.storyscript-ci.com" \
  -d "*.${name}.storyscript-ci.com" \
  --config-dir ${workspace_dir} \
  --work-dir ${workspace_dir} \
  --logs-dir ${workspace_dir}

generated_cert_dir="${workspace_dir}/live/${name}.storyscript-ci.com"
cp -p "${generated_cert_dir}/fullchain.pem" "${tls_certs_dir}/fullchain.pem"
cp -p "${generated_cert_dir}/privkey.pem" "${tls_certs_dir}/privkey.pem"
