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
  pkg.installed
    - pkgs: [gradle]
{% else %}
java and android:
  pkg.installed:
    - pkgs: [default-jdk, default-jre, android-sdk, gradle]
{% endif %}


cryptalabs/Eagle:
  gitlab.latest:
    - target: {{workspace}}/src/{{project}}
    - email: mayeul@cryptalabs.com
    - update_head: False

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/src/{{project}}

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 92
    - tabs: 4

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
