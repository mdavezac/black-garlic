{% set salted = salt['pillar.get']('zsh:salted', grains['userhome'] + "/.salted") %}
{% set homebrew = salt['cmd.shell']('brew --prefix') %}

{{homebrew}}/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve:
  file.managed:
    - user: root
    - group: wheel
    - mode: 4755

{{salted}}/completions/_docker:
  file.managed:
    - source: https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker
    - source_hash: sha1=dbc4fc63f5b16ae74dc893e453ca7d089e53440e
    - makedirs: true
    - mode: 600

{{salted}}/completions/_docker-machine:
  file.managed:
    - source: https://raw.githubusercontent.com/docker/machine/master/contrib/completion/zsh/_docker-machine
    - source_hash: sha1=3b2561eadf28ceb8bfeed4589f57a1ca944efe9d
    - makedirs: true
    - mode: 600
