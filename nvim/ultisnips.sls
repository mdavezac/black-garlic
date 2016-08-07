{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', '~/.config/nvim') %}

{% for filename in salt['pillar.get']('nvim:ultisnips', []) -%}
{{configdir}}/Ultisnips/{{filename}}.snippets:
  file.managed:
    - source: salt://files/nvim/ultisnips/{{filename}}.snippets
    - makedirs: True
{% endfor -%}
