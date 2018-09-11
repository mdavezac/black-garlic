{% set settings = salt['pillar.get']('spacevim:settings', {}) %}
{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set spacevimdir = config.get('spacevimdir', grains['userhome'] + '/.SpaceVim') %}
{% set configdir =  spacevimdir + ".d" %}
{% set virtdirs = config.get('virtualenvs_dir', configdir + "/virtualenvs") %}
{% set brewprefix = "/usr/local/opt/" %}

SpaceVim/SpaceVim.git:
  github.latest:
    - target: {{spacevimdir}}

cquery:
  pkg.installed:
    - options: [--HEAD]

{{configdir}}/cquery.json:
    file.managed:
        - content: { "initializationOptions": { "cacheDirectory": "/tmp/cquery" } }

/var/cquery:
  file.directory:
    - user: mdavezac


{{virtdirs}}:
  file.directory

python2 neovim packages:
  pip.installed:
    - bin_env: {{brewprefix}}/python@2/bin/pip2
    - upgrade: True
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
      - fprettify
      - isort
      - docformatter

python3 neovim packages:
  pip.installed:
    - bin_env: {{brewprefix}}/python/bin/pip3
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
    - contents: {{brewprefix}}/llvm/lib/python2.7/site-packages

{{configdir}}/init.toml:
    file.managed:
        - source: salt://files/spacevim/init.in.toml
        - context:
            configdir: {{configdir}}
            layers: {{salt['pillar.get']('spacevim:layers', [])}}
            options: {{salt['pillar.get']('spacevim:options', {})}}
            settings:
{%-     for key, value in settings.items() %}
                {{key}}: |
                    {{value | indent(20)}}
{%-     endfor %}
            plugins: 
{%-     for plugin in salt['pillar.get']('spacevim:plugins', []) %}
{%        if plugin is string %}
                - {{plugin}}
{%        else %}
{%-         for key, options in plugin.items() %}
                - {{key}}:
{%-           for name, value in options.items() %}
                    {{name}}: {{value}}
{%-           endfor %}
{%-         endfor %}
{%        endif %}
{%-     endfor %}
          inits:
{%-     for key, value in salt['pillar.get']('spacevim:inits', {}).items() %}
                {{key}}: |
                    {{value | indent(20)}}
{%-     endfor %}
        - makedirs: True
        - template: jinja

{{configdir}}/autoload/localcustomconfig.vim:
    file.managed:
        - makedirs: True
        - contents: |
            func! localcustomconfig#before() abort
{%-    for key, value in salt['pillar.get']('spacevim:before', {}).items() %}
                "" {{key}}
                {{value | indent(16)}}
{%-    endfor %}
            endf

            func! localcustomconfig#after() abort
{%-    for key, value in salt['pillar.get']('spacevim:after', {}).items() %}
                "" {{key}}
                {{value | indent(16)}}
{%-    endfor %}
            endf
