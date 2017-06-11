{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.config/nvim') %}
{% set settingsdir = config.get('settingsdir', configdir + "/settings") %}
{% set pluginsrc = config.get('pluginsrc', configdir + "/plugins.vim") %}

{{grains['userhome']}}/.local/share/nvim/site/autoload/plug.vim:
  file.managed:
    - source: https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - source_hash: md5=8f1da3e1dc456736eac2c472a12737d3
    - makedirs: True


{{pluginsrc}}:
  file.managed:
    - source: salt://files/nvim/plugins.vim
    - context:
        config: {{config}}
        plugins: {{salt['pillar.get']('nvim:plugins', [])}}
        plugin_functions: {{salt['pillar.get']('nvim:plugin_functions', [])}}
    - makedirs: True
    - template: jinja

nvim --headless +PlugInstall +qall:
  cmd.run

nvim --headless +PlugUpdate +qall:
  cmd.run

{% for filename in salt['pillar.get']('nvim:settings_files', []) %}
{{settingsdir}}/{{filename}}.vim:
  file.managed:
    - source: salt://files/nvim/settings/{{filename}}.vim
    - makedirs: True
    - template: jinja
    - context: {{config}}
{% endfor %}

{% for settings in salt['pillar.get']('nvim:settings', []) -%}
{%   for name in settings -%}
{{settingsdir}}/{{name}}.vim:
  file.managed:
    - contents_pillar: nvim:settings:{{name}}
    - makedirs: True
    - template: jinja
    - context: {{config}}
{%   endfor -%}
{% endfor -%}

