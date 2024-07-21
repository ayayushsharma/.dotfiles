# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="candy"

HYPHEN_INSENSITIVE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# set the aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# init zoxide
eval "$(zoxide init zsh)"

