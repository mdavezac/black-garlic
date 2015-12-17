{% set repo = "https://www.github.com/sorin-ionescu/prezto" %}
{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set location = home + "/.zprezto" %}

prezto:
  git.latest:
    - name: {{repo}}
    - target: {{location}}
    - submodules: True
    - require:
      - pkg: applications
      - ssh_known_hosts: github.com


{% for filename in ['zlogin', 'zlogout', 'zshrc', 'zshenv'] %}
{{home}}/.{{filename}}:
  file.symlink:
    - target: {{location}}/runcoms/{{filename}}
    - require:
      - git: prezto
{% endfor %}
