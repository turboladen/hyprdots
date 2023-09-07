swayidle -w \
  timeout 300 'swaylock --daemonize' \
  timeout 360 'hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on && kanshi' \
  before-sleep 'swaylock --daemonize' \
  lock 'swaylock --daemonize'
