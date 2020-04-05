#!/bin/bash

set -Eeuo pipefail

# shellcheck disable=SC2154
env=$(cat "${ENV_NAME_FILE}")

gcloud secrets list --filter="labels.env:${env}" --format="json" | jq ".[] | .name" | \
xargs -I secret_name gcloud secrets delete secret_name --quiet
