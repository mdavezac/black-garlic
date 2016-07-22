{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.dcprogs

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - source_dir: {{workspace}}/src/{{project}}
    - makeprg: True
    - footer: |
        let g:ycm_collect_identifiers_from_tags_files=1
        noremap <F5> :Autoformat<CR>
