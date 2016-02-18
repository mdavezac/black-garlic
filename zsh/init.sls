zsh:
  pkg.installed:
    - pkgs:
      - zsh
      - zsh-lovers

include:
  - .powerfonts
  - .prezto
  - .iterm2
  - .completions

{{grains['userhome']}}/.salted:
  file.directory

add pinch to path:
  file.append:
    - name: {{grains['userhome']}}/.salted/zprofile
    - text: |
       alias pinch="{{pillar['condiment_dir']}}/bin/pinch.sh"

add salted bin to path:
  file.append:
    - name: {{grains['userhome']}}/.salted/zprofile
    - text: |
       export PATH=$PATH:{{pillar['condiment_build_dir']}}/bin
