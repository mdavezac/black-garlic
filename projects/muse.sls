{% from "projects/fixtures.sls" import tmuxinator %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

ImperialCollegeLondon/StarMuse:
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - email: m.davezac@imperial.ac.uk
    - update_head: False

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - virtualenv: {{workspace}}/{{python}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/src/{{project}}

{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - system_site_packages: False

python_packages:
  pip.installed:
    - bin_env: {{workspace}}/{{python}}/bin/pip
    - upgrade: True
    - use_wheel: True
    - pkgs: 
      - pip
      - numpy
      - scipy
      - pytest
      - pytest-runner
      - pandas
      - matplotlib
      - jupyter
      - neovim
      - jedi
      - ipython
      - ipdb
      - flake8
      - pylint
      - click
    - env_vars:
        VIRTUAL_ENV: {{workspace}}/{{python}}

shebang_issue:
  cmd.run:
    - cwd: {{workspace}}/{{python}}/bin
    - name: |
        sed -i '' 's#CondimentStation/build/salt-env#workspaces/{{project}}/{{python}}#' \
            $(ag -l Condiment) 
    - unless: test ${\#$(ag -l Condiment)} -eq 0

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
