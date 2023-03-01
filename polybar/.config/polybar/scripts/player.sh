#!/bin/sh
# taken from https://github.com/rbnis/dotfiles/blob/dfd6f956f6d00a1012a3a167d947773095dac7fd/.config/waybar/modules/spotify.sh


players=$(playerctl -l)

text=""
while IFS= read -r player; do
  class=$(playerctl -p "$player" metadata --format '{{lc(status)}}')

  if [[ $class == "playing" ]]; then
    info=$(playerctl -p "$player" metadata --format '{{artist}} - {{title}}')
    if [[ ${#info} -gt 50 ]]; then
      info=$(echo $info | cut -c1-50)"..."
    fi
    text="$info $text"
#  elif [[ $class == "paused" ]]; then
#    text=""
#  elif [[ $class == "stopped" ]]; then
#    text=""
  fi

done <<< "$players"

echo -e "$text"

