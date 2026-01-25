#!/usr/bin/env bash

set -Eeuox pipefail
IFS=$'\n\t'
trap 'echo -e "\n${RED}Error on line $LINENO. Exiting.${NC}"; exit 1' ERR


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


echo -e "${YELLOW}Creating Project Directories - started${NC}"
mkdir -p "$HOME/projects/work"
mkdir -p "$HOME/projects/personal"
echo -e "${YELLOW}Creating Project Directories - finished${NC}"
printf "\n\n"



if [ ! -d ~/.dotfiles ]; then
    echo -e "${YELLOW}Cloning Dotfiles - started${NC}"
    git clone https://github.com/ayayushsharma/.dotfiles.git ~/.dotfiles
    echo -e "${YELLOW}Cloning Dotfiles - finished${NC}"
    printf "\n\n"
fi


echo -e "${YELLOW}Updating System and Installing Dependencies - started${NC}"
if ! grep -q '^ParallelDownloads' /etc/pacman.conf; then
  sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 20/' /etc/pacman.conf || \
  echo 'ParallelDownloads = 20' | sudo tee -a /etc/pacman.conf >/dev/null
else
  sudo sed -i 's/^ParallelDownloads.*/ParallelDownloads = 20/' /etc/pacman.conf
fi

# install for all files in a single command to reduce number of sudo calls
declare -a dep_files=(
    "core.txt"
    "hyprland.txt"
)

tmp_deps="$(mktemp)"
cat ~/.dotfiles/deps/"${dep_files[0]}" > "$tmp_deps"
for file in "${dep_files[@]:1}"; do
  cat ~/.dotfiles/deps/"$file" >> "$tmp_deps"
done
sed -i -E 's/#.*$//' "$tmp_deps"
sed -i '/^\s*$/d' "$tmp_deps"

echo "Installing the following packages using pacman:"
cat "$tmp_deps"
sudo pacman -Syu --noconfirm --needed - < "$tmp_deps"
rm "$tmp_deps"

echo -e "${YELLOW}Updating System and Installing Dependencies - finished${NC}"
printf "\n\n"



echo -e "${YELLOW}Installing yay AUR Helper - started${NC}"
git clone https://aur.archlinux.org/yay-bin.git ~/projects/personal/yay-bin
cd ~/projects/personal/yay-bin || exit
makepkg -si --noconfirm --needed
yay -Y --gendb
yay -Syu --devel --noconfirm --needed
yay -Y --devel --save
cd ~
echo -e "${YELLOW}Installing yay AUR Helper - finished${NC}"
printf "\n\n"


echo -e "${YELLOW}Running Dotfiles Init Script - started${NC}"
~/.dotfiles/init.sh
echo -e "${YELLOW}Running Dotfiles Init Script - finished${NC}"
printf "\n\n"



echo -e "${YELLOW}Setting Zsh as Default Shell - started${NC}"
chsh -s "$(command -v zsh)"
echo -e "${YELLOW}Setting Zsh as Default Shell - finished${NC}"
printf "\n\n"



echo -e "${YELLOW}Enabling Git LFS - started${NC}"
git lfs install
echo -e "${YELLOW}Enabling Git LFS - finished${NC}"
printf "\n\n"



if [ ! -d ~/wallpapers ]; then
    echo -e "${YELLOW}Cloning Wallpaper Repository - started${NC}"
    git clone https://github.com/ayayushsharma/wallpapers.git ~/wallpapers
    echo -e "${YELLOW}Cloning Wallpaper Repository - finished${NC}"
    printf "\n\n"
fi



if [ ! -x "$HOME/.local/bin/mise" ]; then
    echo -e "${YELLOW}Installing Mise - started${NC}"
    curl https://mise.run | sh
    "$HOME/.local/bin/mise" install
    echo -e "${YELLOW}Installing Mise - finished${NC}"
    printf "\n\n"
fi


# install deps from aur.txt
echo -e "${YELLOW}Installing AUR Dependencies - started${NC}"
yay -S --noconfirm --needed - < ~/.dotfiles/deps/aur.txt
echo -e "${YELLOW}Installing AUR Dependencies - finished${NC}"
printf "\n\n"



# Set sddm to start on boot
echo -e "${YELLOW}Enabling SDDM to Start on Boot - started${NC}"
sudo systemctl enable sddm.service
echo -e "${YELLOW}Enabling SDDM to Start on Boot - finished${NC}"
printf "\n\n"


# Set hyprland as the default session in to log in to sddm

echo -e "${YELLOW}Setting Hyprland as Default Session for SDDM - started${NC}"
sudo install -d -m 0755 /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/10-session.conf >/dev/null <<EOF
[Autologin]
User=${USER}
Session=hyprland

[General]
# Optional: explicitly prefer Wayland
EnableWayland=true
EOF
echo -e "${YELLOW}Setting Hyprland as Default Session for SDDM - finished${NC}"
printf "\n\n"

echo -e "${GREEN}Arch Linux Setup Script - finished successfully!${NC}"



# Anything remains here?
