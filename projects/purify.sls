{% from 'projects/fixtures.sls' import tmuxinator %}
{% set python = "python2" %}
{% set compiler = "clang" %}
{% set project = "purify" %}
{% set prefix = salt['funwith.prefix']('purify') %}
{% set openmp = "+openmp" if compiler != "clang" else "-openmp" %}
{% set spack_packages = [
  "fftw %s" % openmp,
  "GreatCMakeCookoff",
  "eigen -mpfr +fftw -metis -scotch -suitesparse ^fftw %s" %openmp,
  "gbenchmark", "Catch", "spdlog", "cfitsio", "bison",
  "boost +python -mpi -multithreaded -program_options"
  + " -random -regex -serialization -signals +singlethreaded -system -test -thread -wave"
]%}
{% if compiler != 'clang' %}
{% do spack_packages.append('openblas %s' % openmp) %}
{% endif %}

{{project}} spack packages:
  spack.installed:
    - pkgs: {{spack_packages}}
    - compiler: {{compiler}}

{{project}} virtualenv:
  virtualenv.managed:
     - name: {{prefix}}
     - python: {{python}}
     - use_wheel: True
     - pip_upgrade: True
     - pip_pkgs:
          - pip
          - numpy
          - scipy
          - pytest
          - pandas
          - cython
          - jupyter

{% do spack_packages.append("casacore +fftw +python ^fftw %s" % openmp) %}
install casacore:
  spack.installed:
    - name: {{spack_packages[-1]}}
    - ignore_deps: True
    - compiler: {{compiler}}

  cmd.run:
    - name: |
        source $SPACK_ROOT/share/spack/setup-env.sh
        {% for pkg in spack_packages %}
        spack load {{pkg}}
        {% endfor %}
        {{prefix}}/bin/pip install python-casacore
    - env:
      - SPACK_ROOT: {{salt['spack.defaults']('directory')}}


purify:
  github.present:
    - target: {{prefix}}/src/{{project}}

  funwith.modulefile:
    - prefix: {{prefix}}
    - cwd: {{prefix}}/src/{{project}}
    - spack: {{spack_packages}}
    - compiler: {{compiler}}
    - virtualenv: {{project}}
{% if compiler == "gcc" %}
    - footer: |
        setenv("CXXFLAGS", "-Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}

  ctags.run:
    - name: {{prefix}}/src/{{project}}
    - exclude: ['.git', 'build']

{{project}} vimrc:
    funwith.add_vimrc:
      - name: {{prefix}}
      - source_dir: {{prefix}}/src/{{project}}
      - makeprg: True
      - footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

{{project}} cppconfig:
    funwith.add_cppconfig:
      - prefix: {{prefix}}
      - cpp11: True
      - source_dir: {{prefix}}/src/{{project}}
      - source_includes:
          - build/external/include
          - build/include/purify
          - cpp
          - cpp/examples
          - include

astro-informatics/sopt:
  github.present:
    - target: {{prefix}}/src/sopt

  file.directory:
    - name: {{prefix}}/src/sopt/build

  cmd.run:
    - name: |
        cmake -DCMAKE_BUILD_TYPE=RelWithDeInfo \
              -DCMAKE_INSTALL_PREFIX={{prefix}} \
              ..
        make install -j 4
    - creates: {{prefix}}/share/cmake/sopt/SoptConfig.cmake
    - cwd: {{prefix}}/src/sopt/build


{{prefix}}/data/:
  file.directory

{{prefix}}/data/WSRT_Measures:
  archive.extracted:
    - source: ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar
    - source_hash: md5=69d0e8aa479585f1be65be2ca51a9e25
    - archive_format: tar
    - tar_options: z
    - if_missing: {{prefix}}/data/WSRT_Measueres/ephemerides

{{tmuxinator('purify', root="%s/src/purify" % prefix)}}
