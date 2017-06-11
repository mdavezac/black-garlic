{% set config = salt['pillar.get']('spacevim:config', {}) %}
{% set configdir = config.get('configdir', grains['userhome'] + '/.Spacevim.d/') %}
{% set backupdir = configdir + "/backup" %}
{% set virtdirs = config.get('virtualenv_dirs', configdir + "/virtualenvs") %}

# - Shougo/neoinclude.vim: {for: cpp}
spacevim:
    layers:
        - tmux
        - incsearch
        - shell
        - lang#go
        - lang#c
        - lang#lua
        - lang#perl
        - lang#rust
        - lang#java
        - lang#javascript
        - lang#vim
        - lang#python
        - lang#xml
        - lang#haskell
        - tools#screensaver

    plugins:
        - JuliaEditorSupport/julia-vim
        - ['JuliaEditorSupport/deoplete-julia',  {'on_ft' : 'julia'}]

    settings:
        global: |
            let $LANG="en_GB.UTF-8"
            let g:spacevim_default_indent = 4
            let g:spacevim_max_column = 100
            let mapleader=","
            let g:spacevim_enable_vimfiler_welcome = 1
            let g:spacevim_enable_debug = 1

            set noswapfile
            set nobackup
            set nowb

            let g:spacevim_plugin_manager = 'vim-plug'
            let g:spacevim_plugin_bundle_dir = '{{configdir}}/cache'

        persistent undo: |
            if has('persistent_undo')
                if !isdirectory('{{backupdir}}')
                    silent !mkdir {{backupdir}} > /dev/null 2>&1
                endif
                set undodir={{backupdir}}
                set undofile
            endif

        languages: |
            unlet g:loaded_python3_provider
            let g:python_host_prog = '{{virtdirs}}/python2/bin/python2'
            let g:python3_host_prog = '{{virtdirs}}/python3/bin/python3'
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
            let g:spacevim_enable_cursorcolumn = 0

        funwith: |
            if $CURRENT_FUN_WITH_HOMEDIR != ""
                let filename = expand("$CURRENT_FUN_WITH_HOMEDIR/.vimrc")
                if filereadable(filename)
                    exe 'source '.filename
                endif
            endif

        tcomment: autocmd FileType julia set commentstring=#\ %s
