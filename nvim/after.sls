{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', '~/.config/nvim') %}

{% for settings in salt['pillar.get']('nvim:after_plugin', []) -%}
{%   for name in settings -%}
{{configdir}}/after/plugin/{{name}}.vim:
  file.managed:
    - contents_pillar: nvim:after_plugin:{{name}}
    - makedirs: True
    - template: jinja
    - context: {{config}}
    - mode: 600
{%   endfor -%}
{% endfor -%}

{% for settings in salt['pillar.get']('nvim:after_ftplugin', []) -%}
{%   for name in settings -%}
{{configdir}}/after/ftplugin/{{name}}.vim:
  file.managed:
    - contents_pillar: nvim:after_ftplugin:{{name}}
    - makedirs: True
    - template: jinja
    - context: {{config}}
    - mode: 600
    {%   endfor -%}
{% endfor -%}
