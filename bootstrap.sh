#!/usr/bin/env bash
# One-run macOS setup. Re-running preserves existing files in a backup directory.
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
LINKS_ONLY=0
SKIP_NVIM=0
case "${1:-}" in
    --links-only) LINKS_ONLY=1 ;;
    --skip-nvim) SKIP_NVIM=1 ;;
    --check) exec "$DOTFILES_DIR/scripts/check.sh" ;;
    --help) echo 'Usage: ./bootstrap.sh [--links-only|--skip-nvim|--check]'; exit 0 ;;
    '') ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
[[ $(uname -s) == Darwin ]] || { echo 'This setup requires macOS.' >&2; exit 1; }
BACKUP_DIR="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)-$$"
info() { printf '\n==> %s\n' "$*"; }
link() {
    local src="$1" dest="$2" relative
    [[ -e "$src" ]] || { echo "Missing source: $src" >&2; exit 1; }
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then return; fi
    mkdir -p "$(dirname "$dest")"
    if [[ -e "$dest" || -L "$dest" ]]; then
        relative="${dest#"$HOME/"}"
        mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
        mv "$dest" "$BACKUP_DIR/$relative"
        echo "Backed up $dest to $BACKUP_DIR/$relative"
    fi
    ln -s "$src" "$dest"
}
# Configs reference ~/dotfiles; support clones elsewhere without rewriting them.
if [[ "$DOTFILES_DIR" != "$HOME/dotfiles" ]]; then
    if [[ -e "$HOME/dotfiles" || -L "$HOME/dotfiles" ]]; then
        [[ "$(cd "$HOME/dotfiles" && pwd -P)" == "$DOTFILES_DIR" ]] || {
            echo '~/dotfiles points at another checkout. Use that checkout or move it first.' >&2; exit 1;
        }
    else
        ln -s "$DOTFILES_DIR" "$HOME/dotfiles"
    fi
fi
if [[ "$LINKS_ONLY" == 0 ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
        echo 'Finish the macOS Command Line Tools installer, then re-run this command.' >&2
        exit 1
    fi
    for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [[ -x "$brew_bin" ]]; then eval "$("$brew_bin" shellenv)"; break; fi
    done
    if ! command -v brew >/dev/null; then
        info 'Installing Homebrew (macOS may request your password)'
        installer="$(mktemp)"
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
        /bin/bash "$installer"
        rm -f "$installer"
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            if [[ -x "$brew_bin" ]]; then eval "$("$brew_bin" shellenv)"; break; fi
        done
    fi
    info 'Installing Brewfile packages, apps, fonts and CLI tools'
    brew bundle install --no-upgrade --file="$DOTFILES_DIR/Brewfile"
    info 'Restoring pinned Git submodules'
    # Old Git configs may rewrite HTTPS to SSH; downloads must work before SSH setup.
    git -c url.https://github.com/.insteadOf=git@github.com: -C "$DOTFILES_DIR" submodule update --init --recursive
fi
info 'Linking active configs'
link "$DOTFILES_DIR/zsh/zshrc.sh" "$HOME/.zshrc"
link "$DOTFILES_DIR/zsh/zprofile.sh" "$HOME/.zprofile"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES_DIR/nvim/.config/init.lua" "$HOME/.config/nvim"
link "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
# Ghostty loads both paths if present: link both to prevent stale overrides.
link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
link "$DOTFILES_DIR/vim/vimrc.vim" "$HOME/.vimrc"
link "$DOTFILES_DIR/env/.env" "$HOME/.env"
link "$DOTFILES_DIR/env/.bash_aliases" "$HOME/.bash_aliases"
link "$DOTFILES_DIR/clang/.clang-format" "$HOME/.clang-format"
link "$DOTFILES_DIR/opencode/plugins/rtk.ts" "$HOME/.config/opencode/plugins/rtk.ts"
mkdir -p "$HOME/.vim/undodir" "$HOME/.nvm" "$HOME/.config/dotfiles" "$HOME/Documents/workspace"
# Preserve existing company-managed Bash startup files; fill fresh-Mac gaps.
[[ -e "$HOME/.bashrc" || -L "$HOME/.bashrc" ]] || link "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
[[ -e "$HOME/.bash_profile" || -L "$HOME/.bash_profile" ]] || link "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
# Generate Git-AI's username-dependent socket path only when the integration exists.
if [[ -x "$HOME/.git-ai/bin/git-ai" ]]; then
    git config --file "$HOME/.config/dotfiles/git-machine.conf" trace2.eventTarget "af_unix:stream:$HOME/.git-ai/internal/daemon/trace2.sock"
    git config --file "$HOME/.config/dotfiles/git-machine.conf" trace2.eventNesting 0
fi
if [[ "$LINKS_ONLY" == 0 && "$SKIP_NVIM" == 0 ]]; then
    info 'Restoring Neovim plugins to lazy-lock.json commits'
    nvim --headless '+Lazy! restore' +qa
    info 'Installing Neovim language servers and syntax parsers'
    nvim --headless -l "$DOTFILES_DIR/scripts/nvim-setup.lua"
fi
if [[ "$LINKS_ONLY" == 0 ]]; then
    info 'Restoring Terminal.app appearance profiles'
    python3 "$DOTFILES_DIR/scripts/terminal-setup.py" "$BACKUP_DIR"
fi
info 'Setup complete. Open a new Ghostty window.'
echo 'Local LLM model files are separate; see local-llm/README.md if needed.'
[[ ! -d "$BACKUP_DIR" ]] || echo "Existing configs backed up at: $BACKUP_DIR"
if [[ "$LINKS_ONLY" == 0 ]]; then "$DOTFILES_DIR/scripts/check.sh"; fi
