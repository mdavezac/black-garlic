{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', '~/.config/nvim') %}
{% set settingsdir = config.get('settingsdir', configdir + "/settings") %}
{% set pluginsrc = config.get('pluginsrc', configdir + "/plugins.vim") %}

{{configdir}}/init.vim:
  file.managed:
    - source: salt://files/nvim/init.vim
    - defaults:
        configdir: {{configdir}}
        beforedir: {{configdir}}/before
        backupsdir: {{configdir}}/backups
        pluginsrc: {{pluginsrc}}
        pluginsdir: {{configdir}}/plugged
        settingsdir: {{settingsdir}}
    - context: {{config}}
    - makedirs: True
    - template: jinja
    - mode: 600

include:
  - .plugins
  - .ultisnips
