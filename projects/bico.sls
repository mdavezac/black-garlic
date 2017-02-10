{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.bico

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - footer: |
          let g:ycm_collect_identifiers_from_tags_files=1
          noremap <F5> :Autoformat<CR>
          let g:formatdef_llvm_cpp = '"clang-format -style=file"'
          let g:formatters_cpp = ['llvm_cpp']

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/sopt

{{project}} cppconfig:
  funwith.add_cppconfig:
    - name: {{workspace}}
    - cpp11: True
    - source_dir: {{workspace}}/src/sopt
    - source_includes:
        - build/external/include
        - build/include
        - include
        - build/python/
        - cpp
        - cpp/examples
{% if python == 'python3' %}
        - {{workspace}}/include/python3.5m
{% else %}
        - {{workspace}}/include/python2.7
{% endif %}
    - defines:
        - SOPT_HAS_NOT_USING

{{tmuxinator(project, root="%s/src/sopt" % workspace)}}
