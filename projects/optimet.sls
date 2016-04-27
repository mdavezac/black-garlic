{% set prefix = salt['funwith.prefix']('optimet') %}
{% set compiler = "clang" %}
{% set belos = "belos %%%s +mpi %sopenmp +lapack ^openblas ^openmpi -tm" % (compiler, "+" if compiler != "clang" else "-") %}
{% set ldflags = "/usr/local/Cellar/gcc/5.3.0/lib/gcc/5/libgfortran.dylib" %}

{% if compiler == "clang" %}
belos spack packages:
  spack.installed:
    - name: {{belos}}
    - environ:
        LDFLAGS: {{ldflags}}
{% endif %}

optimet:
  funwith.present:
    - github: OPTIMET/OPTIMET
    - srcname: optimet
    - spack:
      - f2c %{{compiler}}
      - gsl %{{compiler}}
      - boost %{{compiler}}
      - hdf5 %{{compiler}} -fortran -cxx -mpi
      - Catch %{{compiler}}
      - UCL-RITS.eigen %{{compiler}} +debug
      - openblas %{{compiler}}
      - openmpi %{{compiler}} -tm
      - scalapack %{{compiler}} +debug ^openblas ^openmpi -tm
      - {{belos}}
    - vimrc:
        makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

    - ctags: True
    - cppconfig:
        cpp11: True
        source_includes:
          - build/include/optimet
          - ./
    - footer: |
        setenv("BLA_VENDOR", "OpenBlas")
{% if compiler == "clang" %}
        setenv("LDFLAGS", "{{ldflags}}")
{% elif compiler == "gcc" %}
        setenv("CXXFLAGS", "-Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}
  # recursive clone does not work so well on salt
  cmd.run:
    - name: git submodule update --init --recursive
    - cwd: {{prefix}}/src/optimet
    - creates: {{prefix}}/src/optimet/test-data/.git
