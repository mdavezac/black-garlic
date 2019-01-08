{% set settings = salt['pillar.get']('spacevim:settings', {}) %}
{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set spacevimdir = config.get('spacevimdir', grains['userhome'] + '/.SpaceVim') %}
{% set configdir =  spacevimdir + ".d" %}
{% set virtdirs = config.get('virtualenvs_dir', configdir + "/virtualenvs") %}
{% set brewprefix = "/usr/local/opt/" %}

SpaceVim/SpaceVim.git:
  github.latest:
    - target: {{spacevimdir}}

{{virtdirs}}:
  file.directory

neovim:
   gem.installed

/usr/local/lib/python3.6/site-packages/llvm.pth:
  file.managed:
    - contents: {{brewprefix}}/llvm/lib/python2.7/site-packages


{{configdir}}/init.toml:
  file.serialize:
    - formatter: toml
    - dataset_pillar: spacevim:init


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
