{% set prefix = pillar['funwith']['workspaces'] + "/hunter" %}
hunter:
    funwith.present:
        - github: mdavezac/hunter
        - email: mdavezac@gmail.com

    cookoff.inproject:
        - name: hunter
