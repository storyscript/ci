#!/bin/bash

# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
output_dir="${workspace_dir}/env-creds"

jq -n \
  --arg github_app_id "$GITHUB_APP_ID" \
  --arg github_app_private_key "$GITHUB_APP_PRIVATE_KEY" \
  --arg github_client_id "$GITHUB_CLIENT_ID" \
  --arg github_client_secret "$GITHUB_CLIENT_SECRET" \
  --arg slack_client_id "$SLACK_CLIENT_ID" \
  --arg slack_client_secret "$SLACK_CLIENT_SECRET" \
  --arg slack_signing_secret "$SLACK_SIGNING_SECRET" \
  --arg onegraph_app_id "$ONEGRAPH_APP_ID" \
'{
  github: {
    app_id: $github_app_id,
    app_private_key: $github_app_private_key,
    client_id: $github_client_id,
    client_secret: $github_client_secret
  },
  slack: {
    client_id: $slack_client_id,
    client_secret: $slack_client_secret,
    signing_secret: $slack_signing_secret
  },
  onegraph: {
    app_id: $onegraph_app_id
  }
}' > "${output_dir}/latest.json"
