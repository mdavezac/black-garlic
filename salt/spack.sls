spack:
  github.latest:
    - order: 0
    - target: {{pillar['spack_directory']}}
    - name: llnl/spack.git
    - email: mdavezac@gmail.com

  file.append:
    - name: /Users/{{grains['user']}}/.salted_zprofile
    - text: |
       export SPACK_ROOT={{pillar['spack_directory']}}
       source $SPACK_ROOT/share/spack/setup-env.sh

spack missing clang compilers:
  file.managed:
    - name: /Users/{{grains['user']}}/.spack/compilers.yaml
    - content: |
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
