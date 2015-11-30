applications:
  pkg.installed:
    - pkgs:
      - git
      - vim
{% if grain['os'] == 'Ubuntu' %}
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
