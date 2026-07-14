# =============================================================================
#                           ZSH Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# NVM Configuration (Node Version Manager)
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# -----------------------------------------------------------------------------
# PATH Configuration
# -----------------------------------------------------------------------------
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"  # Java
export PATH="$PATH:$HOME/go/bin"                       # Go
export PATH="$PATH:$HOME/.local/bin"                   # Local binaries (pipx, etc.)
export PATH="$PATH:$HOME/dotfiles/bash"                  # Dotfiles scripts

# -----------------------------------------------------------------------------
# History Configuration
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000              # Lines to keep in memory
SAVEHIST=50000              # Lines to save to file
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_IGNORE_SPACE    # Don't record commands starting with space
setopt HIST_VERIFY          # Show command before executing from history
setopt SHARE_HISTORY        # Share history between sessions
setopt APPEND_HISTORY       # Append to history file
setopt INC_APPEND_HISTORY   # Add commands immediately

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias vi="nvim"
alias vim="nvim"
alias tmux="tmux -2"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"

# -----------------------------------------------------------------------------
# Directory Navigation
# -----------------------------------------------------------------------------
source ~/dotfiles/zsh/plugins/fixls.zsh
chpwd() ls  # List directory contents on cd

# -----------------------------------------------------------------------------
# Completion System
# -----------------------------------------------------------------------------
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive completion

# -----------------------------------------------------------------------------
# Plugins
# -----------------------------------------------------------------------------
source ~/dotfiles/zsh/plugins/zsh-vi-mode.plugin.zsh
source ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh

# -----------------------------------------------------------------------------
# Custom Scripts
# -----------------------------------------------------------------------------
source ~/dotfiles/zsh/keybindings.sh
source ~/dotfiles/zsh/lockbook.sh
source ~/dotfiles/zsh/prompt.sh

# -----------------------------------------------------------------------------
# Google Cloud SDK
# -----------------------------------------------------------------------------
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# -----------------------------------------------------------------------------
# Perl Configuration (only if perl5 directory exists)
# -----------------------------------------------------------------------------
if [ -d "$HOME/perl5" ]; then
    export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
    export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_MB_OPT="--install_base \"$HOME/perl5\""
    export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mohit.singh/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mohit.singh/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mohit.singh/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mohit.singh/google-cloud-sdk/completion.zsh.inc'; fi

# Opencode github mcp Oauth
export GITHUB_MCP_CLIENT_ID="Ov23liDilyBmSyqBlBxX"
export GITHUB_MCP_CLIENT_SECRET="1a8fce81996be7f9ebbbc9f0a0b1ef7b34910977"
