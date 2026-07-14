# =============================================================================
# Dotfiles Auto-Update Manager
# =============================================================================

DOTFILES_DIR="$HOME/dotfiles"

# Only check for updates if we're in an interactive shell and online
dotfiles_update_check() {
    # Skip if not interactive or if we checked recently (within 6 hours)
    local last_check_file="$DOTFILES_DIR/.last_update_check"
    local check_interval=21600  # 6 hours in seconds

    if [[ -f "$last_check_file" ]]; then
        local last_check=$(cat "$last_check_file")
        local now=$(date +%s)
        if (( now - last_check < check_interval )); then
            return 0
        fi
    fi

    echo "Checking for dotfiles updates..."

    # Run fetch in background to avoid blocking
    if git -C "$DOTFILES_DIR" fetch -q 2>/dev/null; then
        local behind=$(git -C "$DOTFILES_DIR" rev-list HEAD...origin/main --count 2>/dev/null)

        if [[ "$behind" -gt 0 ]]; then
            echo "\033[33mUpdates available ($behind commits behind):\033[0m"
            git -C "$DOTFILES_DIR" log ..@{u} --pretty=format:'  %C(red)%aN:%Creset %s %C(green)(%cr)%Creset'
            echo ""
            echo "Run 'dotfiles-update' to apply updates."
        else
            echo "Dotfiles up to date."
        fi

        # Update last check timestamp
        date +%s > "$last_check_file"
    fi
}

# Manual update function
dotfiles-update() {
    echo "Updating dotfiles..."
    git -C "$DOTFILES_DIR" pull --rebase && \
    git -C "$DOTFILES_DIR" submodule update --init --recursive && \
    echo "\033[32mDotfiles updated successfully!\033[0m" && \
    source "$DOTFILES_DIR/zsh/zshrc.sh"
}

# Run update check in background (non-blocking)
(dotfiles_update_check &) 2>/dev/null

# Source main configuration
source "$DOTFILES_DIR/zsh/zshrc.sh"
