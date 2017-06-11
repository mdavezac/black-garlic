{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.config/nvim') %}

{% for filename in salt['pillar.get']('nvim:ultisnips', []) -%}
{{configdir}}/Ultisnips/{{filename}}.snip:
  file.managed:
    - source: salt://files/nvim/ultisnips/{{filename}}.snip
    - makedirs: True
{% endfor -%}
