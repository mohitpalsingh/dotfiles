# Vars
	HISTFILE=~/.zsh_history
	SAVEHIST=10000


# Custom cd
source ~/dotfiles/zsh/plugins/fixls.zsh

chpwd() ls


autoload -U compinit && compinit

source ~/dotfiles/zsh/plugins/zsh-vi-mode.plugin.zsh
source ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zsh/lockbook.sh
source ~/dotfiles/zsh/prompt.sh
