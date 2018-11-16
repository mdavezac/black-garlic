{% set home = grains['userhome'] %}

fish:
  pkg.installed

{{home}}/.config/fish/config.fish:
  file.managed:
    - makedirs: True
    - contents: |
        # Generated file
        # environment variables from fish:envvar pillar
{%- for name, value in salt['pillar.get']('fish:envvar', {}).items() %}
        set -x {{name}} {{value}}
{%- endfor %}

{% for key, text in salt['pillar.get']('fish:settings', {}).items() %}
        # settings: {{key}}
        {{text | indent(8)}}
{% endfor %}


{%- for (name, cmd) in salt['pillar.get']('fish:alias', {}).items() %}
{{home}}/.config/fish/functions/{{name}}.fish:
  file.managed:
    - makedirs: True
    - contents: |
        function {{name}}
            command {{cmd}} $argv
        end
{%- endfor %}

{% for name in salt['pillar.get']('fish:function_files', []) %}
{{home}}/.config/fish/functions/{{name}}.fish:
  file.managed:
    - makedirs: True
    - template: jinja
    - source: salt://files/fish/{{name}}.fish
    - defaults:
      workspaces: {{salt['funwith.defaults']('workspaces')}}
      modulefiles: {{salt['funwith.defaults']('modulefiles')}}
      tmuxinator: {{grains['userhome']}}/.tmuxinator
    - context: {{salt['pillar.get']('funwith', {})}}
{% endfor %}

{% for name in salt['pillar.get']('fish:functions', {}) %}
{{home}}/.config/fish/functions/{{name}}.fish:
  file.managed:
    - makedirs: True
    - contents_pillar: fish:functions:{{name}}
{% endfor %}

{% for (name, value) in salt['pillar.get']('fish:completions', {}).items() %}
{{home}}/.config/fish/completions/{{name}}.fish:
  file.managed:
    - makedirs: True
    - contents: complete -c {{name}} {{value}}
{% endfor %}

'curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher':
  cmd.run:
    - unless: test -e ~/.config/fish/functions/fisher.fish

{{home}}/.config/fish/fishfile:
  file.managed:
    - makedirs: True
    - contents_pillar: fish:plugins

{{grains['userhome']}}/.ctags.d/all.ctags:
  file.managed:
    - source: salt://files/ctags
    - makedirs: True

{{grains['userhome']}}/.julia/config/startup.jl:
  file.managed:
    - source: salt://files/juliarc.jl
    - makedirs: True
