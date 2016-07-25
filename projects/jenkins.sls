{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.jenkins


{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: False
    - footer: au BufRead,BufNewFile *_install setfiletype sh


{{tmuxinator(project, root="%s/src/%s" % (workspace, project))}}
