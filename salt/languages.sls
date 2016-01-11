languages:
  pkg.installed:
    - pkgs:
      - gcc
      - python
      - python3
      - luajit
      - ruby
      - cmake
{% if grains['os'] == 'Ubuntu' %}
      - lua-filesystem
{% elif grains['os'] == 'MacOS' %}
      - lua
{% endif %}

{% for version in [2, 3]:%}
basic python packages for python{{version}}:
  pip.installed:
    - pkgs:
      - numpy
      - scipy
      - ipython[all]
      - cython
      - pytest
      - virtualenv
    - bin_env: /usr/local/bin/pip{{version}}
    - require:
      - pkg: languages
{% endfor %}

julia:
  cask.installed

luarocks install luafilesystem:
  cmd.run:
    - unless: /usr/local/bin/lua -e 'require "elfs"'

luarocks install luaposix:
  cmd.run:
    - unless: /usr/local/bin/lua -e 'require "posix"'

ctags:
  pkg.installed

ninja:
  pkg.installed
