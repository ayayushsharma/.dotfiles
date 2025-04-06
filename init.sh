if [ ! -d ~/.dotfiles ]; then
    echo "Cloning Dotfiles - started"
    git clone https://github.com/ayayushsharma/.dotfiles.git ~/.dotfiles
    echo "Cloning Dotfiles - finished"
fi


echo "Creating Symlinks - started"
cd ~/.dotfiles

stow nvim
stow zsh
stow tmux
stow kitty
echo "Creating Symlinks - finished"
