# .dotfiles

Clone the repository with 

```sh
git clone https://github.com/ayayushsharma/.dotfiles ~/.dotfiles
```

To get the apps running, run the mentioned script for following apps

### Neovim

To get packer running, use
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Then 

```vim
:PackerSync
```
