# Bootstraping the machine

## Arch Linux

```sh
sudo nmcli --ask device wifi connect $wifi_ssid
sudo nmcli connection modify "$wifi_ssid" connection.autoconnect yes
ping google.com -c 3
sudo pacman -Syu --noconfirm git
```
