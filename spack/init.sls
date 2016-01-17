{% set directory = salt['pillar.get']('spack:directory', grains['userhome'] + "/spack") %}
{% set package_dir = directory + "/var/spack/packages" %}
{% set config_dir = salt['pillar.get']('spack:config', grains['userhome'] + "/.spack") %}
spack:
  github.latest:
    - order: 0
    - target: {{directory}}
    - name: llnl/spack.git
    - email: mdavezac@gmail.com
    - rev: develop

  file.append:
    - name: {{grains['userhome']}}/.salted_zprofile
    - text: |
       export SPACK_ROOT={{directory}}
       source $SPACK_ROOT/share/spack/setup-env.sh

{{config_dir}}:
  file.directory

spack missing clang compilers:
  file.managed:
    - name: {{config_dir}}/compilers.yaml
    - source: salt://spack/compilers.yaml

{% for recipe in [
      'GreatCMakeCookoff', 'f2c', 'Eigen',
      'gbenchmark', 'Catch', 'spdlog'] -%}
{{recipe}} spack package file:
  spack.recipe:
    - file: {{recipe}}.py
    - name: {{recipe}}
{% endfor -%}
