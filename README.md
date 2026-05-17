# .dotfiles

## Run Bootstrap

[Bootstrap](./bootstrap/) OR

```sh
git clone https://github.com/ayayushsharma/.dotfiles ~/.dotfiles
```

## Install fonts

```sh
sudo $DOTFILES_SAVE_LOCATION/fonts.sh
```

## For Basic Usage

Pull list of core dependencies with

```sh
curl -fsSL https://raw.githubusercontent.com/ayayushsharma/.dotfiles/main/core_dependencies.txt
```

Setup configs with

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ayayushsharma/.dotfiles/main/init.sh)"
```
