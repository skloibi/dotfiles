#!/usr/bin/env bash

# hack for adding tray only to primary bar taken from https://github.com/polybar/polybar/issues/1070#issuecomment-572478451

BAR_NAME=main
BAR_CONFIG=$HOME/.config/polybar/config.ini

PRIMARY=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
OTHERS=$(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1)

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Wait until the processes have been shut down
#while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar main

# on primary monitor
MONITOR=$PRIMARY polybar --reload -c $BAR_CONFIG $BAR_NAME | tee -a "/tmp/polybar${PRIMARY}.log" & disown
sleep 1

# on all other monitors
for m in $OTHERS; do
  echo "---" | tee -a "/tmp/polybar${m}.log"
  MONITOR=$m polybar --reload -c $BAR_CONFIG $BAR_NAME 2>&1 | tee -a "/tmp/polybar${m}.log" & disown
done

echo "Bars launched..."
