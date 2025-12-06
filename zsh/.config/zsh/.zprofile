export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.dotfiles/bin:$PATH
export PATH=$HOME/.deno/bin:$PATH
export PATH=$HOME/scripts:$PATH
export PATH=/opt/homebrew/opt/openjdk/bin:$PATH

export PERSONAL_DOCKER_NETWORK="my-network"

export DOTFILES_SAVE_LOCATION=$HOME/.dotfiles

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

export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# checks whether language pack is installed and exports
# IS_INSTALLED_"LANGUAGE"=1
function language_detectors() {
    # RUST
    if command -v cargo >/dev/null 2>&1; then
        export IS_INSTALLED_RUST=1
    fi

    # node
    if command -v node >/dev/null 2>&1; then
        export IS_INSTALLED_NODE=1
    fi

    # python
    if command -v python3 >/dev/null 2>&1; then
        export IS_INSTALLED_PYTHON3=1
    fi

    # cpp
    if command -v cpp >/dev/null 2>&1; then
        export IS_INSTALLED_CPP=1
    fi

    # go
    if command -v go >/dev/null 2>&1; then
        export IS_INSTALLED_GO=1
    fi

    # deno
    if command -v deno >/dev/null 2>&1; then
        export IS_INSTALLED_DENO=1
    fi

    # java
    if command -v java >/dev/null 2>&1; then
        export IS_INSTALLED_JAVA=1
    fi
}

language_detectors

export FZF_DEFAULT_OPTS='--tmux 80%,80%'
