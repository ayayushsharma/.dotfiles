#!/usr/bin/env zsh

current_location=$(pwd)
. $DOTFILES_SAVE_LOCATION/init.sh
exec zsh --login
cd "$current_location"
