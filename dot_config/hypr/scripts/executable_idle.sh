swayidle -w \
  timeout 30 'swaylock --daemonize' \
  timeout 36 'hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on && kanshi' \
  before-sleep 'swaylock --daemonize' \
  lock 'swaylock --daemonize'
