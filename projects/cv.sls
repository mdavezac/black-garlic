{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

mdavezac/{{project}}:
  gitlab.latest:
    - target: {{workspace}}
    - update_head: False
    - email: mdavezac@gmail.com

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - cwd: {{workspace}}

{{tmuxinator(project, root=workspace, file="cv.tex")}}
