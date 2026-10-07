#!/usr/bin/env bash
# Read-only migration readiness checks; never installs or sources secrets.
set -uo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
failures=0
check_link() {
    local src="$1" dest="$2"
    if [[ -e "$dest" ]] && [[ "$dest" -ef "$src" ]]; then
        printf 'OK   %s\n' "$dest"
    else
        printf 'FAIL %s does not match repo\n' "$dest"; failures=$((failures + 1))
    fi
}
check_link "$DOTFILES_DIR/zsh/zshrc.sh" "$HOME/.zshrc"
check_link "$DOTFILES_DIR/zsh/zprofile.sh" "$HOME/.zprofile"
check_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
check_link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
check_link "$DOTFILES_DIR/nvim/.config/init.lua" "$HOME/.config/nvim"
check_link "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
check_link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
check_link "$DOTFILES_DIR/vim/vimrc.vim" "$HOME/.vimrc"
check_link "$DOTFILES_DIR/env/.env" "$HOME/.env"
check_link "$DOTFILES_DIR/env/.bash_aliases" "$HOME/.bash_aliases"
check_link "$DOTFILES_DIR/clang/.clang-format" "$HOME/.clang-format"
check_link "$DOTFILES_DIR/opencode/plugins/rtk.ts" "$HOME/.config/opencode/plugins/rtk.ts"
for tool in brew nvim tmux fzf rg fd git-lfs diff-so-fancy node go java uv g++-15 dlv tree-sitter; do
    if command -v "$tool" >/dev/null; then printf 'OK   %s\n' "$tool"
    else printf 'FAIL missing command: %s\n' "$tool"; failures=$((failures + 1)); fi
done
if [[ -d /Applications/Ghostty.app || -d "$HOME/Applications/Ghostty.app" ]]; then
    echo 'OK   Ghostty app'
else echo 'FAIL Ghostty app missing'; failures=$((failures + 1)); fi
status="$(git -C "$DOTFILES_DIR" submodule status --recursive)"
if [[ $? != 0 || "$status" == *$'\n-'* || "$status" == -* || "$status" == *$'\n+'* || "$status" == +* || "$status" == U* ]]; then
    echo 'FAIL submodules missing or differ from recorded commits'; failures=$((failures + 1))
else echo 'OK   pinned submodules'; fi
if ! command -v lockbook >/dev/null; then echo 'NOTE Lockbook bindings require its CLI and account, also missing on the old Mac'; fi
echo "Readiness checks: $failures failure(s). Brewfile installs current versions; it is not a binary version lock."
exit "$((failures > 0))"
