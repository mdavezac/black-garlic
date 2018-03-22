{% from "projects/fixtures.sls" import tmuxinator %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

ImperialCollegeLondon/isale-trunk:
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
      - ipython
      - ipdb
    - env_vars:
        VIRTUAL_ENV: {{workspace}}/{{python}}

shebang_issue:
  cmd.run:
    - cwd: {{workspace}}/{{python}}/bin
    - name: |
        sed -i '' 's#CondimentStation/build/salt-env#workspaces/{{project}}/{{python}}#' \
            $(ag -l Condiment) 
    - unless: test ${\#$(ag -l Condiment)} -eq 0

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - footer: |
       let g:neomake_python_enabled_makers = ["flake8"]
       let g:github_upstream_issues = 1
       let g:gutentags_ctags_exclude = [".tox", "build"]

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
