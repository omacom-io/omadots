#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/omacom-io/omadots.git"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Cloning omadots..."
git clone --depth 1 "$REPO" "$TMPDIR"

echo "Copying config to ~/.config..."
cp -r "$TMPDIR/config/." "$HOME/.config/"
