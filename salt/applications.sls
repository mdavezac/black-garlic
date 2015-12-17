applications:
  pkg.installed:
    - pkgs:
      - git
      - cmake
      - luajit
      - pandoc
      - ruby
{% if grains['os'] == 'Ubuntu' %}
      - slack
      - lua-filesystem
      - context
      - chromium-browser
      - lastpass-cli
{% elif grains['os'] == 'MacOS' %}
      - lua
      - cscope
      - the_silver_searcher
{% endif %}

{% if grains['os'] == 'MacOS' %}
vim:
  pkg.installed:
    - pkgs:
      - vim
      - macvim
    - options: ['--with-lua', '--with-luajit']
    - require:
        - pkg: applications

cask applications:
  cask.installed:
    - pkgs:
      - slack
      - iterm2
{% endif  %}
