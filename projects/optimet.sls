{% set prefix = salt['funwith.prefix']('optimet') %}
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
      - UCL-RITS.scalapack +debug %{{compiler}} ^openblas %{{compiler}} ^openmpi %{{compiler}} -tm
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
        setenv("LDFLAGS", "/usr/local/Cellar/gcc/5.3.0/lib/gcc/5/libgfortran.dylib")
{% if compiler == "gcc" %}
        setenv("CXXFLAGS", "-Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}
  # recursive clone does not work so well on salt
  cmd.run:
    - name: git submodule update --init --recursive
    - cwd: {{optime}}/src/optimet
    - creates: {{optimet}}/src/optimet/test-data/.git
