#!/usr/bin/env zsh

current_location=$(pwd)
. $DOTFILES_SAVE_LOCATION/init.sh
cd $current_location
exec zsh --login
