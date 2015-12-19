{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set location = home + "/.zprezto" %}

prezto:
  github.latest:
    - name: sorin-ionescu/prezto
    - target: {{location}}
    - submodules: True


{% for filename in ['zlogin', 'zlogout', 'zshrc', 'zshenv'] %}
{{home}}/.{{filename}}:
  file.symlink:
    - target: {{location}}/runcoms/{{filename}}
    - require:
      - github: prezto
{% endfor %}
