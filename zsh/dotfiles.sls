{% set home = grains['userhome'] %}
{% set location = salt['pillar.get']('prezto:location', home + "/.zprezto") %}
{% set salted = salt['pillar.get']('zsh:salted', home + "/.salted") %}

{{grains['userhome']}}/.salted:
  file.directory

{% for filename in ['zprofile', 'zshrc', 'zpreztorc'] %}
{{grains['userhome']}}/.{{filename}}:
  file.managed:
    - source: salt://files/zsh/{{filename}}
    - mode: 400
    - template: jinja
    - default:
      home: {{home}}
      prezto: {{location}}
      salted: {{salted}}
{% endfor %}

{{grains['userhome']}}/.ctags:
  file.managed:
    - source: salt://files/ctags
    - makedirs: True
