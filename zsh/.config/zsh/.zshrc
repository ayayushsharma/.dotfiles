#########################################
# Setting up ZSH prompt
#########################################
setopt prompt_subst

autoload -Uz colors && colors
autoload -Uz add-zsh-hook

# Get current Git branch
git_branch() {
  command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null
}

# Check for dirty state
git_dirty() {
  [[ -n "$(command git status --porcelain 2>/dev/null)" ]] && echo " *"
}

# Git prompt info function
git_prompt_info() {
  if command git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git_branch)
    local dirty="%F{red}$(git_dirty)%f"
    echo "%F{green}[$branch$dirty%F{green}]%f"
  fi
}

PROMPT='%B%F{green}%n@%m %F{blue}[%*]%f%b %F{white}[%~]%f $(git_prompt_info)
%F{blue}->%B%F{blue} %#%f%b '

# Case insensitive completion
HYPHEN_INSENSITIVE="true"
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# set the aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f ~/.env ]; then 
    . ~/.env
fi

#########################################
# History Settings
#########################################
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


#########################################
# setting key binds to vim
#########################################
bindkey -v

#########################################
# Changing/making/removing directory
#########################################
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d

# List directory contents
alias ls='ls --color=auto'
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

bindkey '\eOA' history-beginning-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\eOB' history-beginning-search-forward
bindkey '\e[B' history-beginning-search-forward
#########################################
# custom functions
#########################################
. $ZDOTDIR/.zsh_functions

bindkey -s ^f "tmux-sessionizer\n"
