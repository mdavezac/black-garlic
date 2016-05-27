{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = "bempp" %}
{% set prefix = salt['funwith.prefix'](project) %}
{% set compiler = 'clang' %}
{% set spack_packages = ['boost %' + compiler, 'tbb %' + compiler] %}

{{project}}/{{project}}:
  github.present:
    - target: {{prefix}}/src/{{project}}

spack packages:
  spack.installed:
    - pkgs: {{spack_packages}}

{{prefix}}:
  virtualenv.managed:
    - python: python2
    - pip_upgrade: True
    - pip_pkgs:
      - pip
      - pandas
      - numpy
      - scipy
      - jupyter

{{project}}:
  funwith.modulefile:
    - prefix: {{prefix}}
    - cwd: {{prefix}}/src/{{project}}
    - pkgs: {{spack_packages}}
    - virtualenv: True

{{tmuxinator(project, root="%s/src/%s" % (prefix, project))}}
