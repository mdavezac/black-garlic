{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.SpaceVim.d') %}
{% set settings = salt['pillar.get']('spacevim:settings', {}) %}

{{configdir}}/init.vim:
    file.managed:
        - source: salt://files/spacevim/init.in.vim
        - context:
            layers: {{salt['pillar.get']('spacevim:layers', [])}}
            settings:
{%-     for key, value in settings.items() %}
                {{key}}: |
                    {{value | indent(20)}}
                    
{%-     endfor %}
            plugins: {{salt['pillar.get']('spacevim:plugins', [])}}
        - makedirs: True
        - template: jinja
        - mode: 600
