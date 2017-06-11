{% set user = grains['user'] %}
{% set home = grains['userhome'] %}

tmuxinator:
  gem.installed

{{home}}/.tmuxinator:
  file.directory:
    - user: {{user}}

{{home}}/.tmux.conf:
  file.managed:
    - source: salt://files/tmux.conf

#{{home}}/.tmux/plugins/tpm:
#  github.latest:
#    - name: tmux-plugins/tpm
#    - target: {{home}}/.tmux/plugins/tpm
#    - force_fetch: True
