#!/usr/bin/env bash
# =============================================================================
# Dotfiles Bootstrap Script
# Usage: ./bootstrap.sh
# Idempotent: safe to run multiple times.
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m ✓\033[0m %s\n' "$1"; }
fail()  { printf '\033[1;31m ✗\033[0m %s\n' "$1"; }

link() {
    local src="$1" dest="$2"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        ok "linked (already): $dest"
    elif [[ -e "$dest" ]]; then
        mv "$dest" "$dest.bak.$(date +%s)"
        ln -s "$src" "$dest"
        ok "linked (backed up old): $dest"
    else
        mkdir -p "$(dirname "$dest")"
        ln -s "$src" "$dest"
        ok "linked: $dest"
    fi
}

# -----------------------------------------------------------------------------
# 1. Homebrew + packages
# -----------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
ok "brew bundle done"

# -----------------------------------------------------------------------------
# 2. Git submodules (nvim config, zsh plugins)
# -----------------------------------------------------------------------------
git -C "$DOTFILES_DIR" submodule update --init --recursive
ok "submodules initialized"

# -----------------------------------------------------------------------------
# 3. Symlinks
# -----------------------------------------------------------------------------
link "$DOTFILES_DIR/zsh/zshrc.sh"     "$HOME/.zshrc"
link "$DOTFILES_DIR/git/.gitconfig"   "$HOME/.gitconfig"
link "$DOTFILES_DIR/tmux/tmux.conf"   "$HOME/.tmux.conf"
link "$DOTFILES_DIR/nvim/.config/init.lua" "$HOME/.config/nvim"
link "$DOTFILES_DIR/ghostty/config"   "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# -----------------------------------------------------------------------------
# 4. Tmux Plugin Manager
# -----------------------------------------------------------------------------
if [[ ! -d "$HOME/dotfiles/tmux/plugins/tpm/.git" ]]; then
    info "Installing TPM plugins..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/dotfiles/tmux/plugins/tpm" -q
    "$HOME/dotfiles/tmux/plugins/tpm/bin/install_plugins.sh" >/dev/null || true
fi
ok "TPM ready (press prefix+I inside tmux to install/update plugins)"

# -----------------------------------------------------------------------------
# 5. Private secrets file (never committed)
# -----------------------------------------------------------------------------
if [[ ! -f "$HOME/.zsh_secrets" ]]; then
    printf '# Private secrets - NEVER commit this file\n# export GITHUB_MCP_CLIENT_ID=""\n# export GITHUB_MCP_CLIENT_SECRET=""\n' > "$HOME/.zsh_secrets"
    chmod 600 "$HOME/.zsh_secrets"
    fail "created empty ~/.zsh_secrets — fill in your tokens"
else
    ok "~/.zsh_secrets present"
fi

echo ""
info "Done! Start a new shell or run: source ~/.zshrc"
