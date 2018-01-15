{% from "projects/fixtures.sls" import tmuxinator %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

mdavezac/nixboxed:
  github.latest:
    - target: {{workspace}}
    - email: mdavezac@gmai.com
    - update_head: False

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}

{{tmuxinator(project, root=workspace, layout="main-horizontal")}}
