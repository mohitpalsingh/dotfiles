source $(brew --prefix nvm)/nvm.sh

# Exports

export NVM_DIR="$HOME/.nvm"
 [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
 [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# Vars
	HISTFILE=~/.zsh_history
	SAVEHIST=10000

# Alias
	alias vi="nvim"
	alias vim="nvim"

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
