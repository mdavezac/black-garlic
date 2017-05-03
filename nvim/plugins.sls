{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.config/nvim') %}
{% set settingsdir = config.get('settingsdir', configdir + "/settings") %}
{% set pluginsrc = config.get('pluginsrc', configdir + "/plugins.vim") %}

{{configdir}}/autoload/plug.vim:
  file.managed:
    - source: https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - source_hash: md5=a18c6ecaed54d7421fb5d70dc0e0f6d5
    - makedirs: True
    - mode: 600


{{pluginsrc}}:
  file.managed:
    - source: salt://files/nvim/plugins.vim
    - context:
        config: {{config}}
        plugins: {{salt['pillar.get']('nvim:plugins', [])}}
        plugin_functions: {{salt['pillar.get']('nvim:plugin_functions', [])}}
    - makedirs: True
    - template: jinja
    - mode: 600

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
    - mode: 400
{% endfor %}

{% for settings in salt['pillar.get']('nvim:settings', []) -%}
{%   for name in settings -%}
{{settingsdir}}/{{name}}.vim:
  file.managed:
    - contents_pillar: nvim:settings:{{name}}
    - makedirs: True
    - template: jinja
    - context: {{config}}
    - mode: 600
{%   endfor -%}
{% endfor -%}

