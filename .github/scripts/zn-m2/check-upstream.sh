#!/bin/bash
set -euo pipefail

SHOULD_BUILD=false

# Check Passwall release tag
LATEST_PW=$(gh release list -R Openwrt-Passwall/openwrt-passwall -L 1 --json tagName -q '.[0].tagName')
LATEST_TAG=$(gh release list -R "$GITHUB_REPOSITORY" -L 1 --json tagName -q '.[0].tagName' || echo "")
if [ "$LATEST_PW" != "$LATEST_TAG" ]; then
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
