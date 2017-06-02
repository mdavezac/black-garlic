{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.config/nvim') %}
{% set virtdirs = config.get('virtualenv_dirs', configdir + "/virtualenvs") %}

{{virtdirs}}:
  file.directory

{{virtdirs}}/python2:
  virtualenv.managed:
    - python: /usr/bin/python2.7
    - use_wheel: True
    - pip_upgrade: True
    - pip_pkgs: &pip_packages
      - pip
      - numpy
      - scipy
      - pandas
      - pytest
      - cython
      - jupyter
      - neovim
      - autopep8
      - yapf
      - jedi

{{virtdirs}}/python3:
  virtualenv.managed:
    - python: python3
    - use_wheel: True
    - pip_upgrade: True
    - pip_pkgs: *pip_packages

