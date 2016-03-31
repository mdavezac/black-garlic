{% set directory = salt['spack.defaults']('directory') %}
{% set config_dir = salt['spack.defaults']('config_dir') %}
spack:
  github.latest:
    - order: 0
    - target: {{directory}}
    - name: llnl/spack.git
    - email: mdavezac@gmail.com
    - rev: develop

  file.append:
    - name: {{grains['userhome']}}/.salted/zprofile
    - text: |
       export SPACK_ROOT={{directory}}
       source $SPACK_ROOT/share/spack/setup-env.sh

{{config_dir}}:
  file.directory

spack missing clang compilers:
  file.managed:
    - name: {{config_dir}}/compilers.yaml
    - source: salt://spack/compilers.yaml

spack external packages:
  file.managed:
    - name: {{config_dir}}/packages.yaml
    - source: salt://spack/packages.yaml

UCL-RITS:
  spack.add_repo:
    - github: UCL-RITS/spack_packages
