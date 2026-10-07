# Portable fallback for Bash login shells.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done
export PATH="$HOME/.local/bin:$HOME/.git-ai/bin:$HOME/dotfiles/bash:$PATH"
[ ! -f "$HOME/.bashrc" ] || . "$HOME/.bashrc"
