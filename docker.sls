{% set homebrew = salt['cmd.shell']('brew --prefix') %}

{{homebrew}}/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve:
  file.managed:
    - user: root
    - group: wheel
    - mode: 4755

{{grains['userhome']}}/.salted/completions/_docker:
  file.managed:
    - source: https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker
    - source_hash: sha1=9b634c6a45e5b3a09be945e1f221c663cf064337
    - makedirs: true

{{grains['userhome']}}/.salted/completions/_docker-machine:
  file.managed:
    - source: https://raw.githubusercontent.com/docker/machine/master/contrib/completion/zsh/_docker-machine
    - source_hash: sha1=3b2561eadf28ceb8bfeed4589f57a1ca944efe9d
