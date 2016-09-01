{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.cookoff

{{tmuxinator(project, root="%s/src/%s" % (workspace, project))}}
