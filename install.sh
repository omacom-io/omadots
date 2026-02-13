#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/omacom-io/omadots.git"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

section() {
  echo -e "\n==> $1\n"
}

section "Cloning omadots..."
git clone --depth 1 "$REPO" "$TMPDIR"

section "Installing LazyVim..."
[[ -d "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak$TIMESTAMP"
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

section "Copying config to ~/.config..."
mkdir -p "$HOME/.config"
cd "$TMPDIR/config"
find . -type f | while read -r file; do
  target="$HOME/.config/$file"
  mkdir -p "$(dirname "$target")"
  [[ -f "$target" ]] && mv "$target" "$target.bak$TIMESTAMP"
  cp "$file" "$target"
done

section "Configuring git access..."

if ! git config --global user.name &>/dev/null; then
  printf "Git name: "
  read -r GIT_NAME </dev/tty
  git config --global user.name "$GIT_NAME"
else
  echo "Git name already set"
fi

if ! git config --global user.email &>/dev/null; then
  printf "Git email: "
  read -r GIT_EMAIL </dev/tty
  git config --global user.email "$GIT_EMAIL"
else
  echo "Git name already set"
fi
