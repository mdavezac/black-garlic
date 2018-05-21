{% set settings = salt['pillar.get']('spacevim:settings', {}) %}
{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set spacevimdir = config.get('spacevimdir', grains['userhome'] + '/.SpaceVim') %}
{% set configdir =  spacevimdir + ".d" %}
{% set virtdirs = config.get('virtualenvs_dir', configdir + "/virtualenvs") %}

SpaceVim/SpaceVim.git:
  github.latest:
    - target: {{spacevimdir}}
    - email: mdavezac@gmail.com

cquery:
  pkg.installed:
    - options: [--HEAD]

{{configdir}}/cquery.json:
    file.managed:
        - content: { "initializationOptions": { "cacheDirectory": "/tmp/cquery" } }

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

python2 neovim packages:
  pip.installed:
    - bin_env: {{salt['cmd.shell']('brew --prefix python2')}}/bin/pip2
    - upgrade: True
    - use_wheel: True
    - pkgs: &pip_packages
      - pip
      - numpy
      - scipy
      - pandas
      - pytest
      - cython
      - jupyter
      - neovim
      - autopep8
      - pylint
      - frosted
      - yapf
      - jedi
      - black

python3 neovim packages:
  pip.installed:
    - bin_env: {{salt['cmd.shell']('brew --prefix python3')}}/bin/pip3
    - use_wheel: True
    - upgrade: True
    - pkgs: *pip_packages

# {{grains['userhome']}}/.Spacevim:
#   file.symlink:
#       - target: {{spacevimdir}}
# 
# {{grains['userhome']}}/.Spacevim.d:
#   file.symlink:
#       - target: {{configdir}}
# 
# {{grains['userhome']}}/.config/nvim:
#     file.symlink:
#       - target: {{spacevimdir}}

neovim:
   gem.installed

/usr/local/lib/python3.6/site-packages/llvm.pth:
  file.managed:
    - contents: {{salt['cmd.shell']('brew --prefix llvm')}}/lib/python2.7/site-packages
