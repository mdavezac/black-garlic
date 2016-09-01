{% set home = grains['userhome'] %}
{% set config = salt['pillar.get']('zsh:config', {}) %}
{% set location = salt['pillar.get']('prezto:location', home + "/.zprezto") %}
{% set salted = salt['pillar.get']('zsh:salted', home + "/.salted") %}

{% for settings in salt['pillar.get']('zsh:settings', []) -%}
{%   for name in settings -%}
{{salted}}/settings/{{name}}.zsh:
  file.managed:
    - contents_pillar: zsh:settings:{{name}}
    - makedirs: True
    - template: jinja
    - context: {{config}}
{%   endfor -%}
{% endfor -%}


{% set envvar = salt['pillar.get']('zsh:envvar', {}) %}
{{salted}}/envvar.zsh:
  file.managed:
    - makedirs: True
    - contents: |
        # environment variables from zsh:envvar pillar
{%   for name, value in envvar.items() %}
        export {{name}}={{value}}
{%   endfor %}

{% set options = salt['pillar.get']('zsh:options', []) %}
{{salted}}/settings/options.zsh:
  file.managed:
    - makedirs: True
    - contents: |
        # options from zsh:options pillar
{%   for option in options %}
        setopt {{option}}
{%   endfor %}

{% set aliases = salt['pillar.get']('zsh:alias', {}) %}
{{salted}}/settings/alias.zsh:
  file.managed:
    - makedirs: True
    - contents: |
        # aliases from zsh:aliases pillar
{%   for (name, cmd) in aliases.items() %}
        alias {{name}}="{{cmd}}"
{%   endfor %}

{{salted}}/settings/funwith.zsh:
  file.managed:
    - makedirs: True
    - template: jinja
    - source: salt://files/zsh/funwith.zsh
    - defaults:
      workspaces: {{salt['funwith.defaults']('workspaces')}}
      modulefiles: {{salt['funwith.defaults']('modulefiles')}}
      tmuxinator: {{grains['userhome']}}/.tmuxinator
    - context: {{salt['pillar.get']('funwith', {})}}
