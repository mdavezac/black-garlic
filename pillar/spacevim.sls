{% set spacevimdir = grains["userhome"] + "/.config/spacevim" %}
{% set configdir = spacevimdir + ".d" %}
{% set backupdir = configdir + "/backup" %}
{% set virtdirs = configdir + "/virtualenvs" %}
{% set brewprefix = "/usr/local/opt/" %}

spacevim:
    config:
        spacevimdir: {{spacevimdir}}
        configdir: {{configdir}}
        virtualenvs_dir: {{virtdirs}}
    layers:
        - VersionControl
        - colorscheme
        - tmux
        - incsearch
        - tags
        - lang#c
        - lang#csharp
        - lang#tmux
        - lang#vim
        - lang#python
        - lang#julia
        - lang#toml
        - lang#xml
        - tools#screensaver
        - debug
        - lsp
        - autocomplete
        - denite
        - git

    plugins:
        - ["udalov/kotlin-vim", {"on_ft": "kotlin"}]
        - ["saltstack/salt-vim", {"on_ft": "sls"}]
        - ["stephpy/vim-yaml", {"on_ft": ["yaml", "sls"]}]
        - keith/investigate.vim
        - wellle/targets.vim
        - sjl/gundo.vim
        - vim-scripts/ShaderHighLight
        - dag/vim-fish

    settings:
        global: |
            let $LANG="en_GB.UTF-8"
            let g:spacevim_default_indent = 4
            let g:spacevim_max_column = 100
            "" let mapleader=","
            let g:spacevim_enable_vimfiler_welcome = 1
            let g:spacevim_enable_debug = 1

            let g:EditorConfig_exclude_patterns = ["fugitive://.*", "scp://.*"]

            set noswapfile
            set nobackup
            set nowb

            set smartcase
            set ignorecase

            let g:spacevim_plugin_bundle_dir = "{{configdir}}/cache"

            "" let g:spacevim_unite_leader = 'T'
            "" let g:spacevim_windows_leader = 'Y'

            noremap gw gw
            noremap gq gq

        shader: autocmd BufNewFile,BufRead *.cginc set filetype=cg

        persistent undo: |
            if has("persistent_undo")
                if !isdirectory("{{backupdir}}")
                    silent !mkdir {{backupdir}} > /dev/null 2>&1
                endif
                set undodir={{backupdir}}
                set undofile
            endif
        gissues: |
            let g:github_access_token=$GITHUB_API_TOKEN
            let g:gissues_show_errors=1

        python_plugins: |
            let g:python_host_prog = "{{brewprefix}}/python@2/bin/python2"
            let g:python3_host_prog = "{{brewprefix}}/python/bin/python3"
            let g:deoplete#auto_complete_delay = 150
            let g:spacevim_buffer_index_type = 1
            let g:neomake_python_enabled_makers = ["flake8", "pylint"]
            if has("python3")
                let g:ctrlp_map = ""
                nnoremap <silent> <C-p> :Denite file_rec<CR>
            endif
            let g:investigate_dash_for_python="Python3,Pandas,SciPy,NumPy,Matplotlib"

        investigate: |
            let g:investigate_dash_for_cmake="cmake"
            nnoremap <leader>K :call investigate#Investigate("n")<CR>
            vnoremap <leader>K :call investigate#Investigate("v")<CR>

        neoformat: |
            let g:clang2_placeholder_next = ""
            let g:clang2_placeholder_prev = ""


        theme: |
            let g:spacevim_colorscheme_bg = "dark"
            let g:spacevim_colorscheme = "onedark"
            let g:spacevim_enable_os_fileformat_icon = 1
            let g:spacevim_statusline_separator = "curve"
            let g:spacevim_statusline_left_sections = ["winr", "major mode", "syntax checking"]
            let g:spacevim_enable_tabline_filetype_icon = 1
            let g:spacevim_enable_cursorcolumn = 0

        funwith: |
            if $CURRENT_FUN_WITH_HOMEDIR != ""
                let filename = expand("$CURRENT_FUN_WITH_HOMEDIR/.vimrc")
                if filereadable(filename)
                    exe "source " . filename
                endif
            endif

        kotlin: |
            autocmd FileType kotlin set commentstring=//\ %s
            let g:NERDCustomDelimiters = {"kotlin": { "left": "//", "right": "" } }

            let g:investigate_use_dash_for_kotlin=1
            let g:investigate_dash_for_kotlin="kotlin,java,android"
            let g:investigate_use_dash_for_groovy=1
            let g:investigate_dash_for_groovy="gradle,groovy"

            let g:tagbar_type_kotlin = {
              \ "ctagstype" : "kotlin",
              \ "kinds"     : ["c:classes", "i:interfaces", "m:methods", "co:constants"]
            \ }

            let g:neoformat_enabled_kotlin = ["ktlint"]
            let g:neoformat_kotlin_ktlint = {
            \   "exe": "ktlint",
            \   "args": ["-F", "--stdin"],
            \   "stdin": 1
            \ }

        julia: |
            let g:latex_to_unicode_auto = 1
            let g:latex_to_unicode_file_types = ["julia", "markdown", "kotlin", "cpp"]
            let g:latex_to_unicode_tab = 1
            let g:julia_syntax_highlight_deprecated=1
            let g:latex_to_unicode_suggestions=0
            let g:latex_to_unicode_eager=0

            autocmd FileType julia set commentstring=#\ %s

            let g:tagbar_type_julia = {
              \ "ctagstype" : "julia",
              \ "kinds"     : ["a:abstract", "i:immutable", "t:type", "f:function", "m:macro"]
            \ }

            let g:investigate_dash_for_julia="Julia"

        java: |
            if !empty(findfile(".clang-format", $CURRENT_FUN_WITH_DIR))
              let g:neoformat_java_clangformat = {
                \ "exe": "clang-format",
                \ "args": ["-style=file", "-assume-filename=file.java"],
                \ "stdin": 1
                \ }
              let g:neoformat_java_clang_format = g:neoformat_java_clangformat
              let g:neoformat_enabled_java = ["clangformat"]
            end

            let g:investigate_dash_for_java="java,android"

        cpp: |
            if !empty(findfile(".clang-format", $CURRENT_FUN_WITH_DIR))
              let g:neoformat_cpp_clangformat = {
                \ "exe": "clang-format",
                \ "args": ["-style=file"],
                \ "stdin": 1
                \ }
              let g:neoformat_enabled_cpp = ["clangformat"]
            end

            let g:investigate_dash_for_cpp="cpp"

            let g:neomake_cpp_enabled_makers=["gcc", "clang"]
            let compiler_flags=["-Wall", "-Wextra", "-fsyntax-only", "-pedantic"]
            for i in split($CMAKE_PREFIX_PATH, ":")
              for suffix in ["include", "include/eigen3"]
                if isdirectory(i . "/" . suffix)
                  let compiler_flags+=["-isystem" . i . "/" . suffix]
                endif
              endfor
            endfor
            for i in split($CMAKE_INCLUDE_PATH, ";")
              if isdirectory(i)
                let compiler_flags+=["-I" . i]
              endif
            endfor
            if filereadable($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
              let compiler_flags+=readfile($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
            endif
            let g:neomake_cpp_clang_maker = {
              \ "cwd": $CURRENT_FUN_WITH_DIR . "/build",
              \ "args": compiler_flags
              \ }
            let g:neomake_cpp_gcc_maker= {
              \ "exe": "/usr/local/bin/g++-7",
              \ "cwd": $CURRENT_FUN_WITH_DIR . "/build",
              \ "args": compiler_flags
              \ }
            if !empty(findfile("compile_commands.json", $CURRENT_FUN_WITH_DIR . "/build"))
              let g:neomake_cpp_clangtidy_maker = { 
                \ "exe": "{{brewprefix}}/llvm/bin/clang-tidy",
                \ "args": ["-p", $CURRENT_FUN_WITH_DIR . "/build"]
                \ }
                let g:neomake_cpp_enabled_makers+=["clangtidy"]
            end

            let g:chromatica#enable_at_startup = 0
            let g:chromatica#libclang_path="{{brewprefix}}/llvm/lib/libclang.dylib"
            let g:clamp_libclang_file= g:chromatica#libclang_path
            let g:clamp_autostart = 0

        fortran: |
            let g:neomake_fortran_enabled_makers=[]
            let g:neoformat_fortran_fprettify = {
               \ 'exe': 'fprettify',
               \ 'args': ['--silent', '--indent', &shiftwidth],
               \ 'stdin': 1
               \ }
            let g:neoformat_enabled_fortran = ['fprettify']
            let g:investigate_dash_for_fortran="fortran"

        sls: |
            let g:investigate_dash_for_sls="salt"

        dockerfile: |
            let g:investigate_dash_for_dockerfile="docker"

        calendar: |
            let g:calendar_google_calendar=1

        cquery: |
            let g:LanguageClient_serverCommands = {
            \ 'cpp': ['{{brewprefix}}/cquery/bin/cquery', '--log-file=/tmp/cq.log',
            \         '--init={"cacheDirectory":"/var/cquery/"}']                                                                                                                                                                              
            \ }
            let g:LanguageClient_loadSettings = 1
            let g:LanguageClient_settingsPath = '{{spacevimdir}}/cquery.json'

        fish: |
            # autocmd BufRead,BufNewFile *.fish set filetype=fish
            #  autocmd FileType fish compiler fish
            if &shell =~# 'fish$'
                set shell=bash
            endif
