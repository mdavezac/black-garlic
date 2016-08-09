{% set user = grains['user'] %}
{% set home = grains['userhome'] %}
{% set location = home + "/.zprezto" %}

prezto:
  github.latest:
    - name: sorin-ionescu/prezto
    - target: {{location}}
    - submodules: True
    - unless: test -d {{location}}/.git


{%
  set files = [
    'zlogin', 'zlogout', 'zpreztorc', 'zprofile', 'zshrc', 'zshenv'
  ]
%}
{% for filename in files %}
{{home}}/.{{filename}}:
  file.symlink:
    - target: {{location}}/runcoms/{{filename}}
{% endfor %}
