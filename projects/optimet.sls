include:
  - spack

optimet:
  funwith.present:
    - github: OPTIMET/OPTIMET
    - srcname: optimet
    - spack:
      - GreatCMakeCookoff
    - vimrc:
        makeprg: True
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

    - cppconfig:
        cpp11: True
