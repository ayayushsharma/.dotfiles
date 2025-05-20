# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


if [ ! -d $ZSH ]; then
    echo "Installing Oh My Zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
fi

ZSH_THEME="candy"

HYPHEN_INSENSITIVE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# set the aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# init zoxide
eval "$(zoxide init zsh)"

if [ -f ~/.env ]; then 
    . ~/.env
fi

# always aliases
alias lint_py="pylint -r y -s y \`git diff --name-only --staged --diff-filter=d | grep -E '\.py$' | tr '\n' ' '\`"

# custom functions
ff() {
    dir_name=$(find . -type d \( -name node_modules -o -name .git -o -name .venv \) -prune -o -name '*' -type d -print | fzf)
    if [ -n $dir_name ]; then
        cd $dir_name
    fi
}

fhf() {
    dir_name=$(find ~ -type d \( -name node_modules -o -name .git -o -name .venv \) -prune -o -name '*' -type d -print | fzf)
    if [ -n "$dir_name" ]; then
        cd "$dir_name"
    fi
}
