# Bootstraping the machine

## Arch Linux

Run this following commands after a fresh install of Arch to get started:

```sh
sudo nmcli --ask device wifi connect $wifi_ssid
sudo nmcli connection modify "$wifi_ssid" connection.autoconnect yes
ping google.com
sudo pacman -Syu --noconfirm git

curl -fsSl https://conf.sharmaayush.com/bootstrap/archlinux.sh | sh
# OR
curl -fsSl https://raw.githubusercontent.com/ayayushsharma/.dotfiles/main/bootstrap/archlinux.sh | sh
```

### Install fonts

```sh
sudo $DOTFILES_SAVE_LOCATION/fonts.sh
```

### Get USB Headphones to work

```sh
sudo modprobe snd_usb_audio
```

### Changing Login Screen

I like the Sakura theme
```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
```

### Picking default app for opening files in Dolphin does not register it

```sh
mkdir $HOME/.config/menus/
curl -L https://raw.githubusercontent.com/KDE/plasma-workspace/master/menu/desktop/plasma-applications.menu \
    -o $HOME/.config/menus/applications.menu
```
