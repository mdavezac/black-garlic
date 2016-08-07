{% set user = grains['user'] %}
{% set home = grains['userhome'] %}
{% set vimdir = pillar.get('vimdir', home + "/.vim") %}
{% set bundledir = pillar.get('vim_bundler_dir', vimdir + "/bundle") %}
{% set dotdir = pillar.get('dotdir', home + "/.dotfiles") %}

Valloric/YouCompleteMe:
  github.latest:
    - target: {{home}}/.vim/bundle/YouCompleteMe
    - rev: master
    - branch: master

  cmd.run:
    - name: |
        git submodule update --init --recursive
        python install.py --system-boost --clang-completer
    - cwd: {{home}}/.vim/bundle/YouCompleteMe
    - creates:
      - {{bundledir}}/YouCompleteMe/third_party/ycmd/ycm_client_support.so
      - {{bundledir}}/YouCompleteMe/third_party/ycmd/ycm_core.so

{% for filename in ['vimrc', 'gvimrc', 'ycm_extra_conf.py'] %}
{{home}}/.{{filename}}:
  file.symlink:
    - target: {{dotdir}}/vim/{{filename}}
{% endfor %}

{% for dirname in ['undo', 'autoload', '.gissue-cache'] %}
{{vimdir}}/{{dirname}}:
  file.directory
{% endfor %}

VundleVim/Vundle.vim:
  github.latest:
    - target: {{bundledir}}/Vundle.vim

{{vimdir}}/UltiSnips:
  file.symlink:
    - target: {{dotdir}}/vim/UltiSnips

{{vimdir}}/after:
  file.symlink:
    - target: {{dotdir}}/vim/after

{{vimdir}}/vundles.vim:
  file.managed:
    - source: salt://dotfiles/vundles.vim
    - template: jinja
    - defaults:
        vimdir: {{vimdir}}
        bundledir: {{bundledir}}
        dotdir: {{dotdir}}
