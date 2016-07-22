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
