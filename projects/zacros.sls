{% set prefix = salt['funwith.prefix']('zacros') %}
{% set compiler = "gcc" %}

zacros:
  funwith.present:
    - github: UCL/Zacros
    - vimrc:
        makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

    - ctags: True

    - footer: |
{% if compiler == "intel" %}
        setenv("FC", "ifort")
{% elif compiler == "gcc" %}
        setenv("FC", "gfortran-5")
{% endif %}

  git.latest:
    - name: https://github.com/UCL/Zacros.wiki.git
    - target: {{prefix}}/src/wiki
    - update_head : False
    - https_user: mdavezac

