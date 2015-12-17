{% set repo = "https://www.github.com/powerline/fonts" %}
{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set location = pillar['pepper_build_dir'] + "/powerline-fonts" %}

powerfonts:
  git.latest:
    - name: {{repo}}
    - target: {{location}}
    - submodules: True
    - require:
      - pkg: applications
      - ssh_known_hosts: github.com

  cmd.run:
    - creates: {{home}}/Library/Fonts/DejaVu Sans Mono for Powerline.ttf
    - name: bash {{location}}/install.sh
