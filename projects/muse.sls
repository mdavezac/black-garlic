{% from "projects/fixtures.sls" import tmuxinator %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

ImperialCollegeLondon/StarMuse:
  github.latest:
    - target: {{workspace}}/src/{{project}}
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

{{workspace}}/.frosted.cfg:
  file.managed:
    - contents: |
        ignore_frosted_errors=E265,E211,E501,W291,W293,E114,E202
        run_doctests=False

python_packages:
  pip.installed:
    - bin_env: {{workspace}}/{{python}}/bin/pip
    - upgrade: True
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
      - click
      - yapf
      - xarray
      - isort
      - docformatter
    - env_vars:
        VIRTUAL_ENV: {{workspace}}/{{python}}

shebang_issue:
  cmd.run:
    - cwd: {{workspace}}/{{python}}/bin
    - name: |
        sed -i '' 's#CondimentStation/build/salt-env#workspaces/{{project}}/{{python}}#' \
            $(ag -l Condiment) 
    - unless: test ${\#$(ag -l Condiment)} -eq 0
    - shell: /bin/bash

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - width: 80
    - tabs: 4
    - footer: |
       let g:neomake_python_enabled_makers = ["flake8"]
       let g:github_upstream_issues = 1
       let g:gutentags_ctags_exclude = [
          \ ".tox", "build", "packaging", "ReferenceMaterial\&Data"]
       augroup fmt
         au!
       augroup END
       augroup! fmt

{{workspace}}/src/{{project}}/.env:
  file.managed:
    - contents: |
        VIRTUAL_ENV={{workspace}}/{{python}}

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
