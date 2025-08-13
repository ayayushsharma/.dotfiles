export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.dotfiles/bin:$PATH
export PATH=$HOME/.deno/bin:$PATH
export PATH=$HOME/scripts:$PATH

export DOTFILES_SAVE_LOCATION=$HOME/.dotfiles
export NVM_DIR="$HOME/.nvm"
export DENO_TLS_CA_STORE=system

if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
