{% from "projects/fixtures.sls" import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

# java and android:
#   cask.installed:
#     - pkgs:
#       - java
#       - android-studio
#       - android-platform-tools
#
gradle:
  pkg.installed

{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - use_wheel: True
    - pip_pkgs: [pip, numpy, scipy, pytest, pandas, matplotlib, jupyter]

cryptalabs/Eagle:
  gitlab.latest:
    - target: {{workspace}}/src/{{project}}
    - email: mayeul@cryptalabs.com
    - update_head: False

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/src/{{project}}
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 92
    - tabs: 4

julia metadir:
  github.latest:
    - name: JuliaLang/METADATA.jl
    - email: mayeul@cryptalabs.com
    - target: {{workspace}}/julia/v0.5/METADATA
    - force_fetch: True

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
