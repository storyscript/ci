#!/bin/bash

# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
github_credentials_dir="${workspace_dir}/github-credentials"

jq -n \
  --arg client_id "$GITHUB_CLIENT_ID" \
  --arg client_secret "$GITHUB_CLIENT_SECRET" \
  '{client_id: $client_id, client_secret: $client_secret}' > "${github_credentials_dir}"/metadata
