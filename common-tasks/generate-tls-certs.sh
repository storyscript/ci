#!/bin/bash

# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
tls_certs_dir="${workspace_dir}/tls-certs"

cat > "${tls_certs_dir}/fullchain.pem" <<EOF
${TLS_FULL_CHAIN}
EOF

cat > "${tls_certs_dir}/privkey.pem" <<EOF
${TLS_PRIV_KEY}
EOF
