#!/bin/bash

CURR_DIR=$(pwd)

VERSION=$(cat VERSION)
TAG_NAME="v${VERSION}"

# Get the start SHA based on the tag
START_SHA=$(git rev-list -n 1 "${TAG_NAME}")
# Get the end SHA (latest commit on main branch)
END_SHA=$(git rev-parse main)

temp_dir="$(mktemp -d)" && \
  git clone --depth=1 -q https://github.com/kubernetes/release.git "${temp_dir}" && \
  cd "${temp_dir}/"  && \
  go build ./cmd/release-notes/ && \
  mv release-notes /usr/local/bin/

release-notes \
  --start-rev "${START_SHA}" \
  --end-sha "${END_SHA}" \
  --org SachinSahu431 \
  --repo client_golang \
  --branch main \
  --required-author "" \
  --debug \
  --dependencies=false \
  --markdown-links yes \
  --output="CHANGELOG_NEW.md" \
  --go-template "go-template:${CURR_DIR}/changelog-template.tpl"

cat "CHANGELOG_NEW.md"

# append new changelog entries to Unreleased section
sed "/## Unreleased/r CHANGELOG_NEW.md" "${CURR_DIR}/CHANGELOG.md" > "CHANGELOG_TMP.md" && mv "CHANGELOG_TMP.md" "${CURR_DIR}/CHANGELOG.md"
