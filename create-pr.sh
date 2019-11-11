#!/usr/bin/env ash

set -eu

curl -H "Authorization: Bearer ${TOKEN}" -X "POST" -d '{"title": "New Release", "body": "", "head": "release" , "base": "dev"}' https://api.github.com/repos/williammartin/studio/pulls
