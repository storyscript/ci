#!/bin/bash

set -Eeuo pipefail

# INPUTS
workspace_dir="$(pwd)"
release_dir="${workspace_dir}/release"

pushd "${release_dir}" > /dev/null
  # We don't know the name of the extracted directory (looks like {{repository}}-{{commit_hash}})
  # so put it under `source` using `--one-top-level`
  tar -xf source.tar.gz --one-top-level
  pushd "source" > /dev/null
    # Again, we don't know the name of the directory
    # So use a wildcard to copy all files one folder down (inside {{repository}}-{{commit_hash}}) to the current directory (source)
    mv ./*/* .
    # HACK for storyscript/sls: create empty .git directory
    # See https://github.com/storyscript/sls/issues/228
    mkdir .git
  popd > /dev/null
popd > /dev/null
