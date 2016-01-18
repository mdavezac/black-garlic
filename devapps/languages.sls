languages:
  pkg.installed:
    - pkgs:
      - gcc
      - python
      - python3
      - luajit
      - ruby
      - lua
      - node
      - nodeenv

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
      - matplotlib
      - pandas
    - bin_env: /usr/local/bin/pip{{version}}
    - require:
      - pkg: languages
{% endfor %}

julia:
  cask.installed

luarocks install luafilesystem:
  cmd.run:
    - unless: /usr/local/bin/lua -e 'require "lfs"'

luarocks install luaposix:
  cmd.run:
    - unless: /usr/local/bin/lua -e 'require "posix"'
