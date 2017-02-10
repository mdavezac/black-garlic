{% from 'projects/fixtures.sls' import tmuxinator, jedi %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.purify

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}
    - exclude: ['.git', 'build']

{{project}} vimrc:
    funwith.add_vimrc:
      - name: {{workspace}}
      - source_dir: {{workspace}}/src/{{project}}
      - makeprg: True
      - footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

{{project}} cppconfig:
    funwith.add_cppconfig:
      - name: {{workspace}}
      - cpp11: True
      - source_dir: {{workspace}}/src/{{project}}
      - source_includes:
          - build/external/include
          - build/include
          - cpp
          - cpp/examples
          - include

{{tmuxinator('purify', root="%s/src/purify" % workspace)}}
{{jedi(workspace + "/" + python)}}
