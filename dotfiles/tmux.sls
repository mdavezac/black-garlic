{% set user = grains['user'] %}
{% set home = grains['userhome'] %}
{% set dotdir = pillar.get('dotdir', grains['userhome'] + "/.dotfiles") %}

tmuxinator:
  gem.installed

{{home}}/.tmuxinator:
  file.directory:
    - user: {{user}}

{{home}}/.tmux.conf:
  file.symlink:
    - target: {{dotdir}}/tmux.conf
