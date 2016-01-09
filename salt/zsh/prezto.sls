{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set location = home + "/.zprezto" %}

prezto:
  github.latest:
    - name: sorin-ionescu/prezto
    - target: {{location}}
    - submodules: True

  cmd.run:
    - name: |
        cd {{location}}
        git submodule update --init --recursive
    - unless: [[ -e "{{location}}/modules/prompt/external/agnoster" ]]


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
