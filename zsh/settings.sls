{% set home = grains['userhome'] %}
{% set config = salt['pillar.get']('zsh:config', {}) %}
{% set location = salt['pillar.get']('prezto:location', home + "/.zprezto") %}
{% set salted = salt['pillar.get']('zsh:salted', home + "/.salted") %}

{{salted}}/settings.zsh:
  file.managed:
    - makedirs: True
    - contents: |
        # Generated file
{% for key, text in salt['pillar.get']('zsh:settings', {}).items() %}
        # settings: {{key}}
        {{text | indent(8)}}
{% endfor %}

        # options from zsh:options pillar
{%- for option in salt['pillar.get']('zsh:options', []) %}
        setopt {{option}}
{%- endfor %}

        # aliases from zsh:aliases pillar
{%- for (name, cmd) in salt['pillar.get']('zsh:alias', {}).items() %}
        alias {{name}}="{{cmd}}"
{%- endfor %}

{% set envvar = salt['pillar.get']('zsh:envvar', {}) %}
{{salted}}/envvar.zsh:
  file.managed:
    - makedirs: True
    - contents: |
        # environment variables from zsh:envvar pillar
{% for name, value in envvar.items() %}
        export {{name}}={{value}}
{% endfor %}

{{salted}}/funwith.zsh:
  file.managed:
    - makedirs: True
    - template: jinja
    - source: salt://files/zsh/funwith.zsh
    - defaults:
      workspaces: {{salt['funwith.defaults']('workspaces')}}
      modulefiles: {{salt['funwith.defaults']('modulefiles')}}
      tmuxinator: {{grains['userhome']}}/.tmuxinator
    - context: {{salt['pillar.get']('funwith', {})}}
