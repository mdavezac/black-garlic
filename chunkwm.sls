crisidev/chunkwm/chunkwm:
  pkg.installed

koekeishiya/formulae/skhd:
  pkg.installed

{{grains['userhome']}}/.chunkwmrc:
  file.managed:
    - source: salt://files/chunkwm/chunkwmrc

{{grains['userhome']}}/.skhdrc:
  file.managed:
    - source: salt://files/chunkwm/skhdrc
