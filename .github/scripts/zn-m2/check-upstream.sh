#!/bin/bash
set -euo pipefail

SHOULD_BUILD=false

# Check Passwall release tag
LATEST_PW=$(gh release list -R Openwrt-Passwall/openwrt-passwall -L 1 --json tagName -q '.[0].tagName')
LATEST_TAG=$(gh release list -R "$GITHUB_REPOSITORY" -L 1 --json tagName -q '.[0].tagName' || echo "")
# Normalize the revision suffix: the source may record passwall as YY.MM.DD-rN
# while upstream tags it YY.MM.DD-N — the same version. Strip the "r" so
# 26.8.12-r1 (ours) == 26.8.12-1 (upstream) doesn't spuriously trigger a build.
if [ "${LATEST_PW//-r/-}" != "${LATEST_TAG//-r/-}" ]; then
  echo "Passwall release: ${LATEST_TAG:-none} -> $LATEST_PW"
  SHOULD_BUILD=true
else
  echo "Passwall release unchanged ($LATEST_TAG)"
fi

# Check packages repo latest commit
LATEST_SHA=$(gh api repos/Openwrt-Passwall/openwrt-passwall-packages/commits/main --jq .sha)
STORED_SHA=$(cat /tmp/passwall-cache/packages-sha 2>/dev/null || echo "")
if [ "$LATEST_SHA" != "$STORED_SHA" ]; then
  echo "Packages: ${STORED_SHA:-none} -> $LATEST_SHA"
  SHOULD_BUILD=true
else
  echo "Packages unchanged ($LATEST_SHA)"
fi

echo "should_build=$SHOULD_BUILD" >> "$GITHUB_OUTPUT"
echo "latest_pkg_sha=$LATEST_SHA" >> "$GITHUB_OUTPUT"
