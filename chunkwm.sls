{% set home = grains['userhome'] %}

# kitty:
#   cask.installed
# 
# crisisdev/chunkwm/chunkwm:
#   cask.installed
# 
# koekeishiy/formulae/skhd:
#   pkg.installed

{{grains['userhome']}}/.chunkwmrc:
  file.managed:
    - source: salt://files/chunkwm/chunkwmrc

{{grains['userhome']}}/.skhdrc:
  file.managed:
    - source: salt://files/chunkwm/skhdrc

{{grains['userhome']}}/Library/Preferences/kitty/kitty.conf:
  file.managed:
    - source: salt://files/chunkwm/kitty.con
    - makedirs: True
