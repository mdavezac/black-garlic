zsh:
  pkg.installed:
    - pkgs:
      - zsh
      - zsh-lovers

include:
  - zsh.powerfonts
  - zsh.prezto
  - zsh.iterm2

add pinch to path:
  file.append:
    - name: {{grains['userhome']}}/.salted_zprofile
    - text: |
       alias pinch="{{pillar['condiment_dir']}}/bin/pinch.sh"

add salted bin to path:
  file.append:
    - name: {{grains['userhome']}}/.salted_zprofile
    - text: |
       export PATH=$PATH:{{pillar['condiment_build_dir']}}/bin
