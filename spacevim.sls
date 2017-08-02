{% set settings = salt['pillar.get']('spacevim:settings', {}) %}
{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set spacevimdir = config.get('spacevimdir', grains['userhome'] + '/.SpaceVim') %}
{% set configdir =  spacevimdir + ".d" %}
{% set virtdirs = config.get('virtualenvs_dir', configdir + "/virtualenvs") %}

SpaceVim/SpaceVim.git:
  github.latest:
    - target: {{spacevimdir}}
    - email: mdavezac@gmail.com


{{configdir}}/init.vim:
    file.managed:
        - source: salt://files/spacevim/init.in.vim
        - context:
            configdir: {{configdir}}
            layers: {{salt['pillar.get']('spacevim:layers', [])}}
            settings:
{%-     for key, value in settings.items() %}
                {{key}}: |
                    {{value | indent(20)}}
{%-     endfor %}
            plugins: {{salt['pillar.get']('spacevim:plugins', [])}}
        - makedirs: True
        - template: jinja

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
    - venv_bin: python3 -m venv
    - use_wheel: True
    - pip_upgrade: True
    - pip_pkgs: *pip_packages

{{grains['userhome']}}/.Spacevim:
  file.symlink:
      - target: {{spacevimdir}}

{{grains['userhome']}}/.Spacevim.d:
  file.symlink:
      - target: {{configdir}}

{{grains['userhome']}}/.config/nvim:
    file.symlink:
      - target: {{spacevimdir}}

neovim:
  gem.installed
