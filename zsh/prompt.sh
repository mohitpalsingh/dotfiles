# =============================================================================
# ZSH Prompt Configuration
# =============================================================================
# Reference: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

autoload -U colors && colors
setopt PROMPT_SUBST

set_prompt() {
    PS1="["

    # Path (shortened home directory)
    PS1+="%{$fg_bold[blue]%}${PWD/#$HOME/~}%{$reset_color%}"

    # Exit status (only shown if non-zero)
    PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

    # Git branch and status
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        PS1+=', '
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        PS1+="%{$fg[magenta]%}${branch}%{$reset_color%}"

        local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$changes" -gt 0 ]]; then
            PS1+="%{$fg[green]%}+${changes}%{$reset_color%}"
        fi
    fi

    # Sudo indicator
    if sudo -n true 2>/dev/null; then
        PS1+=', %{$fg_bold[red]%}SUDO%{$reset_color%}'
    fi

    PS1+="]: "
}

precmd_functions+=(set_prompt)
