{% set vsdir = grains['userhome'] + '/Library/Application Support/Code/User' %}

{{vsdir}}/settings.json:
    file.managed:
        - source: salt://files/vscode/settings.in.json
        - context:
            secrets: {{salt['pillar.get']('secrets', {})}}
        - makedirs: True
        - template: jinja

{{vsdir}}/keybindings.json:
    file.managed:
        - source: salt://files/vscode/keybindings.json
        - makedirs: True
