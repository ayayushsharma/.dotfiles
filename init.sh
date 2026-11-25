if [ ! -d ~/.dotfiles ]; then
    echo "Cloning Dotfiles - started"
    git clone https://github.com/ayayushsharma/.dotfiles.git ~/.dotfiles
    echo "Cloning Dotfiles - finished"
fi

echo "Creating Symlinks - started"
cd ~/.dotfiles
# git pull --rebase

stow git
stow nvim
stow zsh
stow tmux
stow kitty
stow hyprland
stow karabiner
stow mise
if [ ! -f $HOME/.config/mise/config.toml ]; then
    cp ./mise/.config/mise/config_core.toml ./mise/.config/mise/config.toml
fi
stow scripts --no-folding
echo "Creating Symlinks - finished"
