{% set schemes = salt['pillar.get']('iterm:schemes', {}) %}
{% set build = pillar['condiment_build_dir'] %}

{{build}}/iterm_themes:
  archive.extracted:
    - name: {{pillar['condiment_build_dir']}}/iterm_themes
    - source: https://github.com/mbadolato/iTerm2-Color-Schemes/tarball/master
    - source_hash: md5=6fb0a1e173b2ccfa4a5c16912ac75575
    - archive_format: tar
    - enforce_toplevel: False
    - options: --strip-components=1

{% for scheme in schemes %}
{{build}}/iterm_themes/{{scheme}}.sh:
  file.managed:
    - contents: |
        defaults write \
        -app iTerm     \
        'Custom Color Presets' \
        -dict-add '{{scheme}}' \
        "$(cat "{{build}}/iterm_themes/schemes/{{scheme}}.itermcolors")"

  cmd.run:
    - name: bash "{{build}}/iterm_themes/{{scheme}}.sh"
{% endfor %}

fullscreen iterm:
  mac_param.modify:
    - domain: -app Iterm
    - UseLionStyleFullscreen: 0
