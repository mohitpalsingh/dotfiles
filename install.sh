#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

echo "=== Dotfiles Install ==="

# Symlink configs
echo "Symlinking configs..."

# Neovim
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim/.config/init.lua" "$HOME/.config/nvim"
echo "  nvim -> done"

# Tmux
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
echo "  tmux -> done"

# Git
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
echo "  gitconfig -> done"

# Ghostty
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"
echo "  ghostty -> done"

# ZSH - source manager from .zshrc
if ! grep -q "zshrc_manager" "$HOME/.zshrc" 2>/dev/null; then
    echo "source $DOTFILES/zsh/zshrc_manager.sh" >> "$HOME/.zshrc"
    echo "  zshrc -> added source line"
else
    echo "  zshrc -> already configured"
fi

# Make scripts executable
chmod +x "$DOTFILES/bash/"* 2>/dev/null || true
chmod +x "$DOTFILES/ghostty/tmux_script.sh" 2>/dev/null || true
echo "  scripts -> chmod +x done"

# Brew dependencies
if command -v brew &>/dev/null; then
    echo ""
    echo "Installing brew dependencies..."
    brew install --quiet nvim tmux fzf ripgrep fd diff-so-fancy 2>/dev/null || true
    echo "  brew -> done"
fi

echo ""
echo "=== Done! Restart your shell or run: source ~/.zshrc ==="
