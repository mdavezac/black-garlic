{% set user = grains['user'] %}
{% set home = "/Users/" + user %}

lmod:
  pkg.installed:
    - taps: homebrew/science
    - require:
      - pkg: languages

{{salt['pillar.get']('lmod')['workspaces']}}:
  file.directory
{{salt['pillar.get']('lmod')['modulefiles']}}:
  file.directory
