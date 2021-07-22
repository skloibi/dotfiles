#!/bin/sh
# taken from https://github.com/rbnis/dotfiles/blob/dfd6f956f6d00a1012a3a167d947773095dac7fd/.config/waybar/modules/spotify.sh

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')
icon=""

if [[ $class == "playing" ]]; then
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
  if [[ ${#info} -gt 50 ]]; then
    info=$(echo $info | cut -c1-50)"..."
  fi
  text=$icon" "$info
elif [[ $class == "paused" ]]; then
  text=$icon
elif [[ $class == "stopped" ]]; then
  text=""
fi

echo -e "$text"

