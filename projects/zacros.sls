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
