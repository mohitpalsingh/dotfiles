#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if ! command -v tmux >/dev/null; then
    echo "tmux is missing; run ~/dotfiles/bootstrap.sh" >&2
    exit 1
fi
exec tmux new-session -A -s ghostty
