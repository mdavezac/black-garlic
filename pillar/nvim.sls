{% set configdir = grains['userhome'] + "/.config/salted_nvim/"%}
{% set virtdirs = configdir + "/virtualenvs" %}

# - Shougo/neoinclude.vim: {for: cpp}
nvim:
  config:
    configdir: {{configdir}}
    virtdirs: {{virtdirs}}
  plugins:
    - Shougo/deoplete.nvim: "{'do': function('DoRemote')}"
    - zchee/deoplete-jedi: {for: python}
    - JuliaEditorSupport/julia-vim
    # - autozimu/LanguageClient-neovim: "{ 'do': ':UpdateRemotePlugins' }"
    # - artur-shaik/vim-javacomplete2: {for: java}
    - Shougo/neoinclude.vim: {for: cpp}
    - w0rp/ale: {for: kotlin}
    - Shougo/neosnippet
    - Shougo/neosnippet-snippets
    - neomake/neomake: {for: cpp}
    - tpope/vim-dispatch
    - godlygeek/csapprox # Required for Gblame in terminal vim
    - Shougo/deol.nvim
    - kassio/neoterm
    - itchyny/lightline.vim
    - flazz/vim-colorschemes
    - arakashic/nvim-colors-solarized
    - rakr/vim-one
    - joshdick/onedark.vim
    - morhetz/gruvbox
    - whatyouhide/vim-gotham
    - xsunsmile/showmarks
    - tpope/vim-fugitive
    - tpope/vim-git
    - jaxbot/github-issues.vim
    - sheerun/vim-polyglot
    - saltstack/salt-vim
    # - Chiel92/vim-autoformat
    - sbdchd/neoformat
    - jistr/vim-nerdtree-tabs
    - scrooloose/nerdtree
    - ctrlpvim/ctrlp.vim
    - majutsushi/tagbar
    - rking/ag.vim
    - vim-scripts/IndexedSearch
    - christoomey/vim-tmux-navigator
    - tomtom/tcomment_vim
    - sjl/gundo.vim
    - xolox/vim-easytags
    - tpope/vim-unimpaired # quick-fix and list navigation
    - Rip-Rip/clang_complete: {for: cpp}
    - critiqjo/lldb.nvim: "{'do': function('DoRemote')}"
    - xolox/vim-misc
    - fatih/vim-go: {for: go}
    - rizzatti/dash.vim
    - kassio/neoterm
    - tpope/vim-liquid
    - wellle/targets.vim
    - vim-scripts/AnsiEsc.vim
  plugin_functions:
    - DoRemote: UpdateRemotePlugins
  settings_files:
    - lightline
    - neomake_clang
  settings:
    - gissues: |
        let g:github_access_token=$HOMEBREW_GITHUB_API_TOKEN
        let g:github_issues_no_omni=1
        let g:gissues_show_errors=1
    - tmux-navigator: |
        let g:tmux_navigator_no_mappings = 1
        nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
        nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
        nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
        nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
        " because weird bug in terminals that map <C-h> to <BS> "
        nmap <bs> :<c-u>TmuxNavigateLeft<cr>
    - tcomment: |
        nmap <silent> gcp <c-_>p
        autocmd FileType julia set commentstring=#\ %s
    - gundo: |
        nmap ,u :GundoToggle<CR>
        let g:gundo_right = 1
        let g:gundo_width = 60
    - ctrlp: |
        let g:ctrlp_user_command = 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'
        let g:ctrlp_use_caching = 0
        let g:ctrlp_by_filename = 1
        let g:ctrlp_switch_buffer = 1
        let g:ctrlp_map = ',t'
        nnoremap <silent> ,t :CtrlP<CR>
        nnoremap <silent> ,b :CtrlPBuffer<cr>
        nnoremap <silent> <D-M> :CtrlPBufTag<CR>
    - showmarks: |
        let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY"
    - funwith: |
        if $CURRENT_FUN_WITH_HOMEDIR != ""
          let filename = expand("$CURRENT_FUN_WITH_HOMEDIR/.vimrc")
          if filereadable(filename)
            exe 'source '.filename
          endif
        endif
    - neoterm: |
        let $LANG="en_GB.UTF-8"
        let $LC_ALL="en_GB.UTF-8"
        tnoremap <Esc> <C-\><C-n>
        tnoremap <C-h> <C-\><C-n><C-w>h
        tnoremap <C-j> <C-\><C-n><C-w>j
        tnoremap <C-k> <C-\><C-n><C-w>k
        tnoremap <C-l> <C-\><C-n><C-w>l
        let g:terminal_scrollback_buffer_size=100000
    - colorscheme: |
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        set background=dark
        let g:one_terminal_italics=1
        colorscheme one
        if (has("termguicolors"))
          set termguicolors
        endif
    - deoplete: |
        let g:deoplete#enable_at_startup = 1
{% if grains['os'] == "MacOS" %}
        let g:deoplete#tag#cache_limit_size = 5000000
        let g:deoplete#sources#clang#libclang_path = "/Library/Developer/CommandLineTools/usr/lib/libclang.dylib""
        let g:deoplete#sources#clang#clang_header = "/Library/Developer/CommandLineTools/usr/include""
        let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
{% endif %}
        let g:deoplete#sources#cpp = ['buffer', 'tag']"
        let g:clang_complete_auto = 0
        let g:clang_auto_select = 0
        let g:clang_omnicppcomplete_compliance = 0
        let g:clang_make_default_keymappings = 0
        if !empty(findfile("compile_commands.json", $CURRENT_FUN_WITH_DIR . "/build"))
          let g:deoplete#sources#clang#clang_complete_database = $CURRENT_FUN_WITH_DIR . "/build"
        end
    # - deoplete-java: |
    #     if !exists("g:deoplete#omni_patterns")
    #         let g:deoplete#omni_patterns = {}
    #     endif
    #     let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
    #     autocmd FileType java setlocal omnifunc=javacomplete#Complete
    - neomake: |
        set errorformat+=%Dninja\ -C\ %f
        set errorformat+=%Dmake\ -C\ %f
        augroup neomake_cmd
          autocmd!
          autocmd BufWritePost,BufEnter *.cc,*.cpp,*.h Neomake
        augroup END
    - ale: |
        let g:ale_sign_warning = ''
        let g:ale_sign_error = ''
    - dispatch: nnoremap <F9> :Dispatch<CR>
    - nerdtree: |
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
        map <C-n> :NERDTreeToggle<CR>
    - python: |
        let g:python_host_prog = '{{virtdirs}}/python2/bin/python2'
        let g:python3_host_prog = '{{virtdirs}}/python3/bin/python3'
    - quick_fix_mappings: |
        nmap <silent> ,qc :cclose<CR>
        nmap <silent> ,qo :copen<CR>
    - Autoformat_mapping: |
        noremap <F5> :Neoformat<CR>
        let g:neoformat_enabled_python = ['yapf', 'autopep8']
        let g:neoformat_enabled_cpp = ['clangformat']
        let g:neoformat_enabled_java = ['clangformat']
        let g:neoformat_java_clangformat = neoformat#formatters#java#clangformat()
        let g:neoformat_cpp_clangformat = neoformat#formatters#cpp#clangformat()
        let g:neoformat_java_clangformat.args = ['-assume-filename=file.java']
        if !empty(findfile(".clang-format", $CURRENT_FUN_WITH_DIR))
            let g:neoformat_cpp_clangformat.args = ['-style=file']
            let g:neoformat_java_clangformat.args = ['-style=file', '-assume-filename=file.java']
        end
        let g:neoformat_enabled_kotlin = ['ktlint']
        let g:neoformat_kotlin_ktlint = {
        \   'exe': 'ktlint',
        \   'args': ['-F', '--stdin'],
        \   'stdin': 1
        \ }
    - Tagbar: |
        noremap <F4> :TagbarToggle<CR>
    - neosnippet: |
        let g:neosnippet#snippets_directory=expand("~/.config/nvim/UltiSnips")
        imap <C-k>     <Plug>(neosnippet_expand_or_jump)
        smap <C-k>     <Plug>(neosnippet_expand_or_jump)
        xmap <C-k>     <Plug>(neosnippet_expand_target)
        if has('conceal')
          set conceallevel=2 concealcursor=niv
        endif
        inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    - julia: |
        let g:latex_to_unicode_tab = 1
        let g:tagbar_type_julia = {
          \ 'ctagstype' : 'julia',
          \ 'kinds'     : ['a:abstract', 'i:immutable', 't:type', 'f:function', 'm:macro']
          \ }
        let g:latex_to_unicode_file_types = ".*"
    - easytags: |
        let g:easytags_suppress_ctags_warning = 1
{% if grains['os'] == "MacOS" %}
        let g:easytags_cmd = '/usr/local/bin/ctags'
{% endif %}
        let g:easytags_async = 1
        let g:easytags_syntax_keyword = 'always'
        let g:easytags_include_members = 1
        if $CURRENT_FUN_WITH_HOMEDIR != ""
           let g:easytags_file=expand("$CURRENT_FUN_WITH_DIR/tags")
           set tags=tags;
        endif
    - lldb: |
        nmap <C-q> <Plug>LLBreakSwitch
        nnoremap <F6> :LLmode debug<CR>
        nnoremap <S-F6> :LLmode code<CR>
        nnoremap <F8> :LL continue<CR>
        nnoremap <S-F8> :LL process interrupt<CR>
        nnoremap <F9> :LL print <C-R>=expand('<cword>')<CR>
        vnoremap <F9> :<C-U>LL print <C-R>=lldb#util#get_selection()<CR><CR>
    # - LanguageServerProtocol:
    #     let g:LanguageClient_serverCommands = {
    #         \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    #         \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    #         \ }
    #     " Automatically start language servers. "
    #     let g:LanguageClient_autoStart = 1
    #     nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
    #     nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    #     nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
  after_ftplugin:
    - cpp: |
        setlocal comments-=://
        setlocal comments+=bO://!
        setlocal comments+=b://
  ultisnips: ['_']
