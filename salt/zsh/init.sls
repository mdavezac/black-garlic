zsh:
  pkg.installed:
    - pkgs:
      - zsh
      - zsh-lovers

include:
  - zsh.powerfonts
  - zsh.prezto

# {% if salt['grains.get']('shell') != '/usr/local/bin/zsh' %}
# change shell:
#   cmd.run:
#     - name: chsh -s /usr/local/bin/zsh
#     - require:
#       - pkg: zsh
# {% endif %}
