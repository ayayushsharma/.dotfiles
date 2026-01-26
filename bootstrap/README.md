# Bootstraping the machine

## Arch Linux

Run this following commands after a fresh install of Arch to get started:

```sh
sudo nmcli --ask device wifi connect $wifi_ssid
sudo nmcli connection modify "$wifi_ssid" connection.autoconnect yes
ping google.com
sudo pacman -Syu --noconfirm git

curl -fsSl https://raw.githubusercontent.com/ayayushsharma/.dotfiles/main/bootstrap/archlinux.sh | sh
# OR
curl -fsSl https://ayayushsharma.github.io/.dotfiles/bootstrap/archlinux.sh | sh
```
