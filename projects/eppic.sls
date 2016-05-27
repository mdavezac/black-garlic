{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = "eppic" %}
{% set prefix = salt['funwith.prefix'](project) %}

visual-studio-code:
  cask.installed

maven:
  pkg.installed

{{prefix}}:
  virtualenv.managed:
    - python: python2
    - pip_upgrade: True
    - pip_pkgs:
      - pip
      - pandas
      - numpy
      - scipy
      - messytables
      - jupyter
      - pdftables

{{project}}:
  funwith.modulefile:
    - prefix: {{prefix}}
    - cwd: {{prefix}}/src/EppiRewiewer4
    - virtualenv: True

{{tmuxinator(project, root="%s/src/EppiReviewer4" % prefix)}}

kermitt2/grobid:
  github.present:
    - branch: grobid-parent-0.4.0
    - target: {{prefix}}/src/grobid
