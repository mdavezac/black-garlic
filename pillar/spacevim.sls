{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.Spacevim.d/') %}
{% set virtdirs = config.get('virtualenv_dirs', configdir + "/virtualenvs") %}

# - Shougo/neoinclude.vim: {for: cpp}
spacevim:
    layers:
        - tmux
        - lang#go
        - lang#php
        - lang#c
        - incsearch
        - lang#lua
        - lang#perl
        - lang#swig
        - lang#rust
        - lang#java
        - lang#javascript
        - lang#vim
        - lang#python
        - lang#xml
        - lang#haskell
        - lang#elixir
        - tools#screensaver
        - shell
        - tmux

    plugins:
        - JuliaEditorSupport/julia-vim

    settings:
        global: |
            let g:spacevim_default_indent = 4
            let g:spacevim_max_column = 100
            let g:spacevim_enable_vimfiler_welcome = 1
            let g:spacevim_enable_debug = 1
            let g:deoplete#auto_complete_delay = 150
            let g:spacevim_buffer_index_type = 1
            let g:neomake_vim_enabled_makers = ['vimlint', 'vint']
            if has('python3')
                let g:ctrlp_map = ''
                nnoremap <silent> <C-p> :Denite file_rec<CR>
            endif
            let g:clang2_placeholder_next = ''
            let g:clang2_placeholder_prev = ''

        theme: |
            let g:spacevim_colorscheme = 'one'
            let g:spacevim_colorscheme_bg = 'dark'
            let g:spacevim_enable_os_fileformat_icon = 1
            let g:spacevim_statusline_separator = 'curve'
            let g:spacevim_enable_tabline_filetype_icon = 1
            let g:spacevim_enable_cursorcolumn = 1

        funwith: |
            if $CURRENT_FUN_WITH_HOMEDIR != ""
                let filename = expand("$CURRENT_FUN_WITH_HOMEDIR/.vimrc")
                if filereadable(filename)
                    exe 'source '.filename
                endif
            endif

        tcomment: autocmd FileType julia set commentstring=#\ %s
