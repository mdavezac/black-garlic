{% set directory = salt['pillar.get']('spack:directory', grains['userhome'] + "/spack") %}
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
    - contents: |
        compilers:
            darwin-x86_64:
                gcc@4.2.1:
                    cc: /usr/bin/gcc
                    cxx: /usr/bin/g++
                    f77: None
                    fc: None
                gcc@5.2.0:
                    cc: /usr/local/bin/gcc-5
                    cxx: /usr/local/bin/g++-5
                    f77: /usr/local/bin/gfortran
                    fc: /usr/local/bin/gfortran
                clang@7.0.3:
                    cc: /usr/bin/cc
                    cxx: /usr/bin/CC
                    f77: None
                    fc: None
