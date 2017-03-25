{% from "projects/fixtures.sls" import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

mdavezac/spack:
  github.latest:
    - target: {{workspace}}/{{project}}
    - email: m.davezac@ucl.ac.com
    - update_head: False


{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - use_wheel: True
    - pip_pkgs: [pip, numpy, scipy, pytest, pandas, jupyter]


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/{{project}}
    - footer: |
        setenv("SPACK_ROOT", "{{workspace}}/{{project}}")
        set_alias("ispack", "spack python -c \"from IPython import embed; embed()\"")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 80
    - tabs: 4

{{tmuxinator(project, root="%s/%s" % (workspace, project), layout="main-horizontal")}}
