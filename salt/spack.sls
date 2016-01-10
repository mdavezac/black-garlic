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
       source $PATH:$SPACK_ROOT/share/spack/setup-env.sh

spack missing clang compilers:
  file.append:
    - name: /Users/{{grains['user']}}/.spackconfig
    - text: |
        [compiler "apple"]
            cc = /usr/bin/cc
            cxx = /usr/bin/cxx
            f77 = none
            fc = none
