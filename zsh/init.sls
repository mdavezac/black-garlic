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

{{grains['userhome']}}/.ctags:
  file.managed:
    - source: salt://files/ctags
    - makedirs: True
