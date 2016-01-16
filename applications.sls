applications:
  pkg.installed:
    - pkgs:
      - git
      - pandoc
{% if grains['os'] == 'Ubuntu' %}
      - slack
      - context
      - chromium-browser
      - lastpass-cli
{% elif grains['os'] == 'MacOS' %}
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
        - pkg: languages

cask applications:
  cask.installed:
    - pkgs:
      - slack
      - iterm2
      - google-chrome
      - dropbox
{% endif  %}
