#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar main
for m in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR=$m polybar --reload main &
done

echo "Polybar launched..."
