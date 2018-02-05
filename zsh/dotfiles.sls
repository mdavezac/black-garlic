{% set home = grains['userhome'] %}
{% set location = salt['pillar.get']('prezto:location', home + "/.zprezto") %}
{% set salted = salt['pillar.get']('zsh:salted', home + "/.salted") %}

{{grains['userhome']}}/.salted:
  file.directory

{% for filename in ['zprofile', 'zshrc', 'zpreztorc'] %}
{{grains['userhome']}}/.{{filename}}:
  file.managed:
    - source: salt://files/zsh/{{filename}}
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

{{grains['userhome']}}/.juliarc.jl:
  file.managed:
    - source: salt://files/juliarc.jl
    - template: jinja
    - context:
        packages: {{salt['pillar.get']('julia:packages', [])}}

{{grains['userhome']}}/.condarc:
  file.managed:
    - contents: |
        envs_dirs: [{{grains['userhome']}}/.conda/envs]
