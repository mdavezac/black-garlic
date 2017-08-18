{% from "projects/fixtures.sls" import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

{% if grains['os'] == "MacOS" %}
java and android:
  cask.installed:
    - pkgs:
      - java
      - android-studio
      - android-platform-tools
  pkg.installed:
    - pkgs: [gradle]
{% else %}
java and android:
  pkg.installed:
    - pkgs: [default-jdk, default-jre, android-sdk, gradle]
{% endif %}


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

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/src/{{project}}
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")
        setenv("ANDROID_HOME", "{{grains['userhome']}}/Library/Android/sdk")

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
    - target: {{workspace}}/julia/v0.6/METADATA
    - force_fetch: True

CryptaLabs/ExtractRandom.jl:
  github.latest:
    - email: mayeul@cryptalabs.com
    - target: {{workspace}}/julia/v0.6/ExtractRandom

CryptaLabs/LibRaw.jl:
  github.latest:
    - email: mayeul@cryptalabs.com
    - target: {{workspace}}/julia/v0.6/LibRaw


{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
