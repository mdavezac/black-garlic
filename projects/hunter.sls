{% from 'projects/fixtures.sls' import tmuxinator, cookoff %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

mdavezac/hunter:
  github.latest:
    - target: {{workspace}}/src/hunter
    - email: mdavezac@gmail.com
    - update_head: False

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - tabs: 2
    - width: 80

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
{{cookoff(prefix=workspace)}}
