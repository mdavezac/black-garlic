{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

mdavezac/{{project}}:
  github.latest:
    - target: {{workspace}}
    - email: mdavezac@gmail.com
    - update_head: False

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - cwd: {{workspace}}

{{tmuxinator(project, root=workspace, file="cv.tex")}}
