{% set schemes = salt['pillar.get']('iterm:schemes', {}) %}
{% set build = pillar['condiment_build_dir'] %}

{{build}}/iter_themse:
  file.directory:
    - makedirs: True

{{build}}/iterm_themes archive:
  archive.extracted:
    - name: {{pillar['condiment_build_dir']}}/iterm_themes
    - source: https://github.com/mbadolato/iTerm2-Color-Schemes/tarball/master
    - source_hash: md5=49ecb540aa63bcfa4457b523c00a070c
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
