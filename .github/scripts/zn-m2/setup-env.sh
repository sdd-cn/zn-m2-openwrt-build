#!/bin/bash
set -euo pipefail

sudo apt-get update
curl -s https://raw.githubusercontent.com/immortalwrt/build-scripts/master/init_build_environment.sh | sudo bash
sudo apt-get install -y rename pigz libfuse-dev upx subversion clang lua5.1 liblua5.1-0-dev
sudo apt-get autoremove -y --purge
sudo apt-get clean
sudo timedatectl set-timezone "$TZ"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
git config --global init.defaultBranch master
sudo mkdir -p /workdir
sudo chown "$USER:$(id -gn)" /workdir
