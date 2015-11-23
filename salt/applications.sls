applications:
  pkg.installed:
    - pkgs:
      - git
{% if grains['os'] == 'Ubuntu' %}
      - vim
      - silversearcher-ag
      - slack
      - cmake
      - luajit
      - lua-filesystem
      - context
      - pandoc
      - chromium-browser
      - lastpass-cli
{% endif %}
