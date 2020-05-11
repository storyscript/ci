#!/bin/bash

set -Eeuxo pipefail

# ENV
: "${SITE_ID:?}"
: "${NETLIFY_AUTH_TOKEN:?}"

# INPUTS
workspace_dir=$(pwd)
tls_certs_dir="${workspace_dir}/tls-certs"

# <renewCertsDateCheck>
# taken from control-tower (https://github.com/EngineerBetter/control-tower/blob/master/fly/pipeline.go#L33)
now_seconds=$(date +%s)
not_after=$(echo | openssl s_client -connect storyscript.com:443 2>/dev/null | openssl x509 -noout -enddate)
expires_on=${not_after#'notAfter='}
expires_on_seconds=$(date --date="$expires_on" +%s)
let "seconds_until_expiry = $expires_on_seconds - $now_seconds"
let "days_until_expiry = $seconds_until_expiry / 60 / 60 / 24"
if [ $days_until_expiry -gt 2 ]; then
  echo Not renewing HTTPS cert, as they do not expire in the next two days.
  exit 0
fi
# </renewCertsDateCheck>

pushd "${tls_certs_dir}" > /dev/null
  http POST "https://api.netlify.com/api/v1/sites/${SITE_ID}/ssl" \
    Authorization:"Bearer ${NETLIFY_AUTH_TOKEN}" \
    certificate=="$(cat fullchain.pem)" \
    key=="$(cat privkey.pem)"
popd > /dev/null
