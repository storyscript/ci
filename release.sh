#!/usr/bin/env bash

set -eu

pushd studio
  git config user.email "will@storyscript.io"
  git config user.name "William Martin"

  yarn
  yarn release --release minor
popd
