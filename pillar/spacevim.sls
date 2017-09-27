{% set spacevimdir = grains['userhome'] + '/.config/spacevim' %}
{% set configdir = spacevimdir + ".d" %}
{% set backupdir = configdir + "/backup" %}
{% set virtdirs = configdir + "/virtualenvs" %}

spacevim:
    config:
        spacevimdir: {{spacevimdir}}
        configdir: {{configdir}}
        virtualenvs_dir: {{virtdirs}}
    layers:
        - tmux
        - incsearch
        - tags
        - lang#c
        - lang#java
        - lang#javascript
        - lang#vim
        - lang#python
        - lang#xml
        - tools#screensaver

    plugins:
        - JuliaEditorSupport/julia-vim
        - ['udalov/kotlin-vim', {'on_ft': 'kotlin'}]
        - ['saltstack/salt-vim', {'on_ft': 'sls'}]
        - ['stephpy/vim-yaml', {'on_ft': ['yaml', 'sls']}]
        # - ['DonnieWest/VimStudio', {'on_ft': ['java', 'kotlin', 'groovy']}]
        - keith/investigate.vim
        - wellle/targets.vim
        - sjl/gundo.vim
        # - ['JuliaEditorSupport/deoplete-julia',  {'on_ft' : 'julia'}]
        # - Shougo/neoinclude.vim

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

            set smartcase
            set ignorecase

            let g:spacevim_plugin_bundle_dir = '{{configdir}}/cache'

            noremap \ f
            noremap « F
            noremap gw gw
            noremap gq gq
            noremap F4 TagBarToggle

        persistent undo: |
            if has('persistent_undo')
                if !isdirectory('{{backupdir}}')
                    silent !mkdir {{backupdir}} > /dev/null 2>&1
                endif
                set undodir={{backupdir}}
                set undofile
            endif

        python_plugins: |
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

        investigate: |
            let g:investigate_dash_for_cmake="cmake"
            nnoremap <leader>K :call investigate#Investigate('n')<CR>
            vnoremap <leader>K :call investigate#Investigate('v')<CR>

        neoformat: |
            noremap <F5> :Neoformat<CR>
            let g:clang2_placeholder_next = ''
            let g:clang2_placeholder_prev = ''

        theme: |
            let g:spacevim_colorscheme_bg = 'dark'
            let g:spacevim_colorscheme = 'molokai'
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

        kotlin: |
            autocmd FileType kotlin set commentstring=//\ %s
            let g:NERDCustomDelimiters = {'kotlin': { 'left': '//', 'right': '' } }

            let g:investigate_use_dash_for_kotlin=1
            let g:investigate_dash_for_kotlin="kotlin,java,android"

            let g:tagbar_type_kotlin = {
              \ 'ctagstype' : 'kotlin',
              \ 'kinds'     : ['c:classes', 'i:interfaces', 'm:methods', 'co:constants']
            \ }

            let g:neoformat_enabled_kotlin = ['ktlint']
            let g:neoformat_kotlin_ktlint = {
            \   'exe': 'ktlint',
            \   'args': ['-F', '--stdin'],
            \   'stdin': 1
            \ }

        julia: |
            let g:latex_to_unicode_auto = 1
            let g:latex_to_unicode_file_types = ["julia", "markdown", "kotlin"]
            let g:latex_to_unicode_tab = 1
            let g:julia_syntax_highlight_deprecated=1
            let g:latex_to_unicode_suggestions=0
            let g:latex_to_unicode_eager=0

            autocmd FileType julia set commentstring=#\ %s

            let g:tagbar_type_julia = {
              \ 'ctagstype' : 'julia',
              \ 'kinds'     : ['a:abstract', 'i:immutable', 't:type', 'f:function', 'm:macro']
            \ }

            let g:investigate_dash_for_julia="Julia"

        java: |
            if !empty(findfile(".clang-format", $CURRENT_FUN_WITH_DIR))
              let g:neoformat_java_clangformat = {
                \ 'exe': 'clang-format',
                \ 'args': ['-style=file', '-assume-filename=file.java'],
                \ 'stdin': 1
                \ }
              let g:neoformat_java_clang_format = g:neoformat_java_clangformat
              let g:neoformat_enabled_java = ['clangformat']
            end

            let g:investigate_dash_for_java="java,android"

        cpp: |
            if !empty(findfile(".clang-format", $CURRENT_FUN_WITH_DIR))
              let g:neoformat_cpp_clangformat = {
                \ 'exe': 'clang-format',
                \ 'args': ['-style=file'],
                \ 'stdin': 1
                \ }
              let g:neoformat_enabled_cpp = ['clangformat']
            end
            let g:investigate_dash_for_cpp="cpp"

        sls: |
            let g:investigate_dash_for_sls="SaltStack"

        dockerfile: |
            let g:investigate_dash_for_dockerfile="docker"
