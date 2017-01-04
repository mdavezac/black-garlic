{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

{% from 'projects/fixtures.sls' import tmuxinator %}
{{tmuxinator(project, root="%s/src/%s" % (workspace, project))}}

include:
  - chilly-oil.projects.{{project}}

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
