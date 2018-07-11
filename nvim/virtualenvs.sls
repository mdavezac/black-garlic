{% set config = salt['pillar.get']('nvim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.config/nvim') %}
{% set virtdirs = config.get('virtualenvs_dir', configdir + "/virtualenvs") %}

{{virtdirs}}:
  file.directory

{{virtdirs}}/python2:
  virtualenv.managed:
    - python: /usr/bin/python2.7
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
    - venv_bin: python3 -m venv
    - pip_upgrade: True
    - pip_pkgs: *pip_packages

