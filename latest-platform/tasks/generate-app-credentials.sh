#!/bin/bash

# INPUTS
workspace_dir=$(pwd)

# OUTPUTS
app_credentials_dir="${workspace_dir}/app-credentials"

jq -n '
{
  github:
    client_id: env.GITHUB_CLIENT_ID,
    client_secret: env.GITHUB_CLIENT_SERET
  slack:
    client_id: env.SLACK_CLIENT_ID
    client_secret: env.SLACK_CLIENT_SECRET
}
' > "${app_credentials_dir}"/metadata
# NOTE: since this file is used in a later task which is shared with latest-platform,
# it is named "metadata" here to match the name used by pool-resource in latest-platform
