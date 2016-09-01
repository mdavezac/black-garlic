{% set home = grains['userhome'] %}
{% set location = salt['pillar.get']('prezto:location', home + "/.zprezto") %}

prezto:
  github.latest:
    - name: sorin-ionescu/prezto
    - target: {{location}}
    - submodules: True
    - unless: test -d {{location}}/.git


{% set files = ['zlogin', 'zlogout', 'zshenv'] %}
{% for filename in files %}
{{home}}/.{{filename}}:
  file.symlink:
    - target: {{location}}/runcoms/{{filename}}
{% endfor %}

{{location}}/modules/prompt/functions/prompt_funwith_setup:
  file.managed:
    - source: salt://files/zsh/prompt_funwith.zsh
