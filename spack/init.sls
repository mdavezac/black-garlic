{% set directory = salt['pillar.get']('spack:directory', grains['userhome'] + "/spack") %}
{% set ucl_repo = directory + "/var/spack/repos/ucl" %}
{% set package_dir = ucl_repo + "/packages" %}
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

UCL-RITS:
  spack.add_repo:
    - github: UCL-RITS/spack_packages
