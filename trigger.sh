if [ -d ~/.config/nvim ]; then
    echo "You already have a nvim config"
    echo "Remove ~/.config/nvim" 
    exit 1
fi

if [ -h ~/.config/nvim ]; then
    echo "Found symlink set for nvim configs dir"
    echo "Removing symlink and setting and placing own settings"
    rm ~/config/nvim
fi

ln -s ~/.dotfiles/nvim ~/.config/nvim
