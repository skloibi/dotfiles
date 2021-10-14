#!/bin/sh
# taken from https://github.com/rbnis/dotfiles/blob/dfd6f956f6d00a1012a3a167d947773095dac7fd/.config/waybar/modules/spotify.sh

class=$(playerctl metadata --format '{{lc(status)}}')

if [[ $class == "playing" ]]; then
  info=$(playerctl metadata --format '{{artist}} - {{title}}')
  if [[ ${#info} -gt 50 ]]; then
    info=$(echo $info | cut -c1-50)"..."
  fi
  text=$info
elif [[ $class == "paused" ]]; then
  text=""
elif [[ $class == "stopped" ]]; then
  text=""
fi

echo -e "$text"

