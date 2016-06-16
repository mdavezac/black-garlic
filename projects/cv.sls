{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = "cv" %}
{% set prefix = salt['funwith.prefix']('cv') %}

mdavezac/{{project}}:
  github.present:
    - target: {{prefix}}

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - cwd: {{prefix}}

{{tmuxinator(project, root=prefix, file="cv.tex")}}
