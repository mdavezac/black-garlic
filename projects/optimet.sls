{% set compiler = salt['pillar.get']('compiler', 'gcc') %}
{% set python = salt['pillar.get']('python', 'python3') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.optimet

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "ninja\\ -vC\\ $CURRENT_FUN_WITH_DIR/build/"
    - footer: |
          let g:ycm_collect_identifiers_from_tags_files=1
          let g:formatdef_llvm_cpp = '"clang-format -style=file"'
          let g:formatters_cpp = ['llvm_cpp']
          let g:github_upstream_issues = 1

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}
    - exclude: ['.git', 'build']

{{project}} cppconfig:
  funwith.add_cppconfig:
    - name: {{workspace}}
    - cpp11: True
    - source_dir: {{workspace}}/src/{{project}}
    - source_includes:
        - build/include/optimet
        - ./


{% from 'projects/fixtures.sls' import tmuxinator, jedi %}
{{tmuxinator(project, file="Solver.cpp")}}
{{jedi(workspace + "/" + python)}}
