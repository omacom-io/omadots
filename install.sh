#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/omacom-io/omadots.git"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

section() {
  echo -e "\n==> $1"
}

section "Cloning Omadots..."
git clone --depth 1 "$REPO" "$TMPDIR"

section "Installing LazyVim..."
rm -rf ~/.config/nvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

section "Copying dots to ~/.config..."
mkdir -p "$HOME/.config"
cp -rf "$TMPDIR/config/." "$HOME/.config/"
for dir in "$TMPDIR/config"/*/; do
  echo "✓ $(basename "$dir")"
done

section "Configuring shell..."
case "$(basename "$SHELL")" in
zsh)
  cat >"$HOME/.zshrc" <<'EOF'
source ~/.config/shell/all
source ~/.config/shell/zoptions
EOF
  echo '. ~/.zshrc' >"$HOME/.zprofile"
  echo "✓ Zsh"
  ;;
bash)
  echo 'source ~/.config/shell/all' >"$HOME/.bashrc"
  echo '. ~/.bashrc' >"$HOME/.bash_profile"
  ln -snf "$HOME/.config/shell/inputrc" "$HOME/.inputrc"
  echo "✓ Bash"
  ;;
esac
