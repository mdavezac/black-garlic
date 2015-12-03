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
{% endif %}

{% if grains['os'] == 'MacOS' %}
vim:
  pkg.installed:
    - options: ['--with-lua', '--with-luajit']
    - require:
        - pkg: applications
{% endif  %}
