{% set scheme_name = pillar['iterm']['name'] %}
iterm2:
  cask.installed:
    - name: iterm2

  file.managed: 
    - name: {{pillar['pepper_build_dir']}}/{{scheme_name}}
    - contents: |
        defaults write \
        -app iTerm     \
        'Custom Color Presets' \
        -dict-add '{{scheme_name}}' \
        '{
          {% for key, color in pillar['iterm']['colors'].items() %}
          "{{key}}" = {
            "Red component" = "{{color[0]}}";
            "Green component" = "{{color[1]}}";
            "Blue component" = "{{color[2]}}";
          };
          {% endfor %}
        }'

  cmd.run:
    - name: bash {{pillar['pepper_build_dir']}}/{{scheme_name}}
