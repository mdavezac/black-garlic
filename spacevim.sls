{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.SpaceVim.d') %}
{% set settings = salt['pillar.get']('spacevim:settings', {}) %}
{% set virtdirs = config.get('virtualenv_dirs', configdir + "/virtualenvs") %}

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
        - mode: 600

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

