{% set user = grains['user'] %}
{% set home = grains['userhome'] %}
{% set workspaces = pillar.get('funwith:workspaces', home + "/workspaces") %}
{% set optimetdir = workspaces + "/optimet/src/optimet" %}

optimet:
  funwith.present:
    - github: OPTIMET/OPTIMET
    - srcname: optimet
    - spack:
      - f2c %clang
      - gsl %clang
      - boost %clang
      - hdf5 %clang -fortran -cxx
      - Catch %clang
      - UCL-RITS.eigen %clang
      - openblas %clang
      - openmpi %clang -tm
      - UCL-RITS.scalapack %clang ^openblas %clang ^openmpi %clang -tm
    - vimrc:
        makeprg: True
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
          - .
  # recursive clone does not work so well on salt
  cmd.run:
    - name: git submodule update --init --recursive
    - cwd: {{optimetdir}}
    - creates: {{optimetdir}}/test-data/.git
