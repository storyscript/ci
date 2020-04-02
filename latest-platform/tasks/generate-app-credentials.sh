#!/bin/bash

# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
app_credentials_dir="${workspace_dir}/app-credentials"

jq -n \
  --arg github_client_id "$GITHUB_CLIENT_ID" \
  --arg github_client_secret "$GITHUB_CLIENT_SECRET" \
  --arg slack_client_id "$SLACK_CLIENT_ID" \
  --arg slack_client_secret "$SLACK_CLIENT_SECRET" \
  --arg slack_signing_secret "$SLACK_SIGNING_SECRET" \
'{
  github: {
    client_id: $github_client_id,
    client_secret: $github_client_secret
  },
  slack: {
    client_id: $slack_client_id,
    client_secret: $slack_client_secret,
    signing_secret: $slack_signing_secret
  }
}' > "${app_credentials_dir}"/metadata
# NOTE: since this file is used in a later task which is shared with latest-platform,
# it is named "metadata" here to match the name used by pool-resource in latest-platform
