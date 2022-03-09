#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Wait until the processes have been shut down
#while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar main
for m in $(polybar --list-monitors | cut -d":" -f1); do
  echo "---" | tee -a "/tmp/polybar${m}.log"
  MONITOR=$m polybar --config=$HOME/.config/polybar/config.ini main 2>&1 | tee -a "/tmp/polybar${m}.log" & disown
done

echo "Bars launched..."
