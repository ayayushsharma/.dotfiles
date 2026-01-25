#!/usr/bin/env bash

set -Eeuox pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    echo -e "${RED}Run as a normal user (script uses sudo as needed).${NC}"
    exit 1
fi

command -v pacman >/dev/null 2>&1 || {
    echo -e "${RED}This script requires Arch Linux (pacman not found).${NC}"
    exit 1
}

# ---------- Helpers ----------
info() { echo -e "${YELLOW}$*${NC}"; }
ok()   {
    echo -e "${GREEN}$*${NC}"
    printf "\n\n"
}
fail() {
    echo -e "${RED}$*${NC}"
    exit 1
}

_cleanup_hooks=()
cleanup() {
    for hook in "${_cleanup_hooks[@]}"; do
        eval "$hook" || true
    done
}
trap 'echo -e "\n${RED}Error on line $LINENO. Exiting.${NC}"; exit 1' ERR
trap 'cleanup' EXIT

# ---------- Create Project Directories ----------
info "Creating Project Directories - started"
mkdir -p "$HOME/projects/work"
mkdir -p "$HOME/projects/personal"
ok   "Creating Project Directories - finished"

# ---------- Dotfiles clone/update ----------
if [[ ! -d "$HOME/.dotfiles/.git" ]]; then
    info "Cloning Dotfiles - started"
    git clone https://github.com/ayayushsharma/.dotfiles.git "$HOME/.dotfiles"
    ok "Cloning Dotfiles - finished"
else
    info "Updating Dotfiles - started"
    git -C "$HOME/.dotfiles" pull --rebase --autostash || true
    ok "Updating Dotfiles - finished"
fi

info "Updating System and Installing Dependencies - started"

# Enable ParallelDownloads = 20
sudo sed -i '/^[#[:space:]]*ParallelDownloads[[:space:]]*=.*/d' /etc/pacman.conf
echo 'ParallelDownloads = 20' | sudo tee -a /etc/pacman.conf >/dev/null

declare -a dep_files=(
    "core.txt"
    "hyprland.txt"
)

tmp_deps="$(mktemp)"
_cleanup_hooks+=("rm -f '$tmp_deps'")
>"$tmp_deps"

for file in "${dep_files[@]}"; do
    if [[ -f "$HOME/.dotfiles/deps/$file" ]]; then
        cat "$HOME/.dotfiles/deps/$file" >>"$tmp_deps"
    fi
done

sed -i -E 's/#.*$//' "$tmp_deps"
sed -i '/^\s*$/d' "$tmp_deps"
awk '!seen[$0]++' "$tmp_deps" >"${tmp_deps}.uniq"  && mv "${tmp_deps}.uniq" "$tmp_deps"

if [[ -s "$tmp_deps" ]]; then
    echo "Installing the following packages using pacman:"
    cat "$tmp_deps"
    sudo pacman -Syu --noconfirm --needed - <"$tmp_deps"
else
    info "No pacman packages found in deps."
fi
ok "Updating System and Installing Dependencies - finished"

# ---------- Installing yay AUR Helper ----------
info "Installing yay AUR Helper - started"
if ! command -v yay >/dev/null 2>&1; then
    builddir="$(mktemp -d)"
    _cleanup_hooks+=("rm -rf '$builddir'")
    git clone https://aur.archlinux.org/yay-bin.git "$builddir/yay-bin"
    pushd "$builddir/yay-bin" >/dev/null
    makepkg -si --noconfirm --needed
    popd >/dev/null
else
    info "yay already installed, skipping build"
fi
yay -Y --gendb || true
yay -Syu --devel --noconfirm --needed || true
yay -Y --devel --save || true
ok "Installing yay AUR Helper - finished"

# ---------- Dotfiles Init Script ----------
if [[ -x "$HOME/.dotfiles/init.sh" ]]; then
    info "Running Dotfiles Init Script - started"
    "$HOME/.dotfiles/init.sh"
    ok "Running Dotfiles Init Script - finished"
else
    info "Dotfiles init not executable or missing: $HOME/.dotfiles/init.sh"
    fail "Cannot continue without dotfiles initialization."
fi

# ---------- Set Zsh as Default Shell ----------
info "Setting Zsh as Default Shell - started"
zsh_path="$(command -v zsh || true)"
[[ -n "$zsh_path" ]] || fail "zsh not found. Ensure zsh is installed (add to deps) and re-run."
if ! grep -qxF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$(readlink -f "$current_shell")" != "$(readlink -f "$zsh_path")" ]]; then
    sudo chsh -s "$zsh_path"
    info "Default shell changed to zsh. You may need to log out/in."
else
    info "Zsh already the default shell."
fi
ok "Setting Zsh as Default Shell - finished"

# ---------- Wallpapers repo ----------
if [[ ! -d "$HOME/wallpapers/.git" ]]; then
    info "Cloning Wallpaper Repository - started"
    if command -v git-lfs >/dev/null 2>&1 || pacman -Q git-lfs >/dev/null 2>&1; then
        info "Enabling Git LFS for wallpapers - started"
        git lfs install
        ok "Enabling Git LFS for wallpapers - finished"
        git clone https://github.com/ayayushsharma/wallpapers.git "$HOME/wallpapers"
        ok "Cloning Wallpaper Repository - finished"
    else
        info "git-lfs not installed; Make sure git lfs is installed to get full wallpaper set."
    fi
else
    info "Updating Wallpaper Repository - started"
    git -C "$HOME/wallpapers" pull --rebase --autostash || true
    ok "Updating Wallpaper Repository - finished"
fi

# ---------- Mise ----------
if [[ ! -x "$HOME/.local/bin/mise" ]]; then
    info "Installing Mise - started"
    curl -fsSL https://mise.run | sh
    "$HOME/.local/bin/mise" install || true
    "$HOME/.local/bin/mise" --version || true
else
    info "Mise present; running 'mise install' to sync tools"
    "$HOME/.local/bin/mise" install || true
fi
ok "Installing Mise - finished"

# ---------- AUR packages from aur.txt ----------
info "Installing AUR Dependencies - started"
if [[ -f "$HOME/.dotfiles/deps/aur.txt" ]]; then
    aur_tmp="$(mktemp)"
    _cleanup_hooks+=("rm -f '$aur_tmp'")
    sed -E 's/#.*$//' "$HOME/.dotfiles/deps/aur.txt" | sed '/^\s*$/d' | awk '!seen[$0]++' >"$aur_tmp"
    if [[ -s "$aur_tmp" ]]; then
        yay -S --noconfirm --needed - <"$aur_tmp"
    else
        info "No AUR packages found."
    fi
else
    info "AUR list not found: $HOME/.dotfiles/deps/aur.txt"
fi
ok "Installing AUR Dependencies - finished"

# ---------- SDDM Configuration ----------
info "Enabling SDDM to Start on Boot - started"
if systemctl list-unit-files | grep -q '^sddm.service'; then
    if systemctl is-enabled --quiet sddm.service; then
        info "sddm.service already enabled"
    else
        sudo systemctl enable sddm.service
    fi
else
    fail "sddm.service not found; ensure sddm is installed (add to deps)."
fi
ok "Enabling SDDM to Start on Boot - finished"

# ---------- Set Hyprland as Default Session for SDDM ----------
info "Setting Hyprland as Default Session for SDDM - started"
sudo install -d -m 0755 /etc/sddm.conf.d
SDDM_CFG="$(
            cat <<EOF
[Autologin]
User=${USER}
Session=hyprland
[General]
EnableWayland=true
EOF
)"
sddm_file_path="/etc/sddm.conf.d/10-session.conf"
if [[ ! -f /usr/share/wayland-sessions/hyprland.desktop ]]; then
    fail "Note: /usr/share/wayland-sessions/hyprland.desktop not found. Ensure Hyprland is installed."
fi
if [[ ! -f $sddm_file_path ]]; then
    info "SDDM session config not found, creating new one"
    printf "%s" "$SDDM_CFG" | sudo tee "$sddm_file_path" >/dev/null
fi
ok "Setting Hyprland as Default Session for SDDM - finished"

ok "Arch Linux Setup Script - finished successfully!"
