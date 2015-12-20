{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set vimdir = home + "/.vim" %}
{% set bundledir = vimdir + "/bundle" %}
{% set dotfiles = home + "/.dotfiles" %}

Valloric/YouCompleteMe:
  github.latest:
    - target: {{home}}/.vim/bundle/YouCompleteMe

  cmd.run:
    - name: |
        cd {{home}}/.vim/bundle/YouCompleteMe
        git submodule update --init --recursive
        mkdir -p third_party/ycmd/build
        cd third_party/ycmd/build
        prefix=$(/usr/local/bin/python-config --prefix)
        cmake -DPYTHON_LIBRARY=$prefix/lib/python2.7/config/libpython2.7.dylib \
              -DPYTHON_INCLUDE_DIR=$prefix/include/python2.7 \
              -DCMAKE_BUILD_TYPE=Release \
              -DUSE_CLANG_COMPLETER=ON \
              ../cpp
        make -j4
    - creates:
      - {{home}}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so
      - {{home}}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so
    - require:
      - pkg: languages


{% for filename in ['vimrc', 'gvimrc', 'ycm_extra_conf.py'] %}
{{home}}/.{{filename}}:
  file.symlink:
    - target: {{dotfiles}}/vim/{{filename}}
    - require:
      - github: dotfiles
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
    - target: {{dotfiles}}/vim/UltiSnips

{{vimdir}}/after:
  file.symlink:
    - target: {{dotfiles}}/vim/after

{{vimdir}}/vundles.vim:
  file.managed:
    - source: salt://dotfiles/vundles.vim
    - template: jinja
    - defaults:
        vimdir: {{vimdir}}
        bundledir: {{bundledir}}
