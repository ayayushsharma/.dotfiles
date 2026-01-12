DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Smarter completion initialization
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' $ZDOTDIR/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C -u
fi

export ZSH="$HOME/.oh-my-zsh"

if [[ ! -f $ZSH/oh-my-zsh.sh ]]; then
    echo "Preparing Oh My Zsh --> Started"
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
    echo "Preparing Oh My Zsh --> Finished"
fi

ZSH_CUSTOM=$ZSH/custom

if [[ ! -f $ZSH_CUSTOM/themes/spaceship.zsh-theme ]]; then
    echo "Preparing Spaceship --> Started"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    mkdir -p /home/ayushsha/.oh-my-zsh/custom/themes/spaceship/
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    echo "Preparing Spaceship --> Finished"
fi

plugins=(
    vi-mode
    aws
    podman
)

ZSH_THEME="spaceship"

source $ZSH/oh-my-zsh.sh

HYPHEN_INSENSITIVE="true"

# set the aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.env ]; then 
    . ~/.env
fi

. $ZDOTDIR/.zsh_functions
#########################################
# History Settings
#########################################
HISTSIZE=10000
SAVEHIST=5000
HISTDUP=erase

bindkey -s ^f "tmux-sessionizer\n"
eval "$($HOME/.local/bin/mise activate zsh)"

#########################################
# Aliases
#########################################
alias icat="kitten icat"
alias vi="nvim"

source <(fzf --zsh)
