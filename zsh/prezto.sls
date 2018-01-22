{% set home = grains['userhome'] %}
{% set location = salt['pillar.get']('prezto:location', home + "/.zprezto") %}

git@github.com:sorin-ionescu/prezto:
  git.latest:
    - target: {{location}}
    - submodules: True

#{% set files = ['zlogin', 'zlogout', 'zshenv'] %}
#{% for filename in files %}
#{{home}}/.{{filename}}:
#  file.symlink:
#    - user: {{grains['user']}}
#    - target: {{location}}/runcoms/{{filename}}
#{% endfor %}

{{location}}/modules/prompt/functions/prompt_funwith_setup:
  file.managed:
    - source: salt://files/zsh/prompt_funwith.zsh
