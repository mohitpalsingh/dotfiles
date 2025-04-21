source $(brew --prefix nvm)/nvm.sh

# Exports

export NVM_DIR="$HOME/.nvm"
 [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
 [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

export PATH="$PATH:$HOME/go/bin"

# Vars
	HISTFILE=~/.zsh_history
	SAVEHIST=10000

# Alias
	alias vi="nvim"
	alias vim="nvim"
    alias tmux="tmux -2"

# Custom cd
source ~/dotfiles/zsh/plugins/fixls.zsh

chpwd() ls


autoload -U compinit && compinit

source ~/dotfiles/zsh/plugins/zsh-vi-mode.plugin.zsh
source ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/dotfiles/zsh/lockbook.sh
source ~/dotfiles/zsh/prompt.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mohits/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mohits/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mohits/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mohits/google-cloud-sdk/completion.zsh.inc'; fi

PATH="/Users/mohits/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/mohits/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/mohits/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/mohits/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/mohits/perl5"; export PERL_MM_OPT;

# Created by `pipx` on 2025-01-27 20:34:38
export PATH="$PATH:/Users/mohits/.local/bin"
