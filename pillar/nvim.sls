nvim:
  plugins:
    - Shougo/deoplete.nvim: "{'do': function('DoRemote')}"
    - zchee/deoplete-jedi: {for: python}
    - zchee/deoplete-clang: {for: cpp}
    - Shougo/neoinclude: {for: cpp}
    - Shougo/neosnippet
    - Shougo/neosnippet-snippets
    - neomake/neomake
    - tpope/vim-dispatch
    - godlygeek/csapprox # Required for Gblame in terminal vim
    - itchyny/lightline.vim
    - flazz/vim-colorschemes
    - arakashic/nvim-colors-solarized
    - morhetz/gruvbox
    - whatyouhide/vim-gotham
    - xsunsmile/showmarks
    - tpope/vim-fugitive
    - tpope/vim-git
    - jaxbot/github-issues.vim
    - sheerun/vim-polyglot
    - saltstack/salt-vim
    - jtratner/vim-flavored-markdown
    - Chiel92/vim-autoformat
    - jistr/vim-nerdtree-tabs
    - scrooloose/nerdtree
    - ctrlpvim/ctrlp.vim
    - majutsushi/tagbar
    - rking/ag.vim
    - vim-scripts/IndexedSearch
    - christoomey/vim-tmux-navigator
    - tomtom/tcomment_vim
    - sjl/gundo.vim
    - vim-scripts/AutoTag
    - vim-scripts/AnsiEsc.vim
    - tpope/vim-unimpaired # quick-fix and list navigation
    - critiqjo/lldb.nvim: "{'do': function('DoRemote')}"
    - xolox/vim-colorscheme-switcher
    - xolox/vim-misc
  plugin_functions:
    - DoRemote: UpdateRemotePlugins
  settings_files:
    - lightline
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
        tnoremap <Esc> <C-\><C-n>
        tnoremap <C-h> <C-\><C-n><C-w>h
        tnoremap <C-j> <C-\><C-n><C-w>j
        tnoremap <C-k> <C-\><C-n><C-w>k
        tnoremap <C-l> <C-\><C-n><C-w>l
        let g:terminal_scrollback_buffer_size=100000
    - colorscheme: |
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        set background=dark
        colorscheme hybrid_reverse
        let g:colorscheme_manager_file=expand("$HOME/.config/nvim/colorscheme")
    - deoplete: |
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#sources#clang#libclang_path = "/Library/Developer/CommandLineTools/usr/lib/libclang.dylib"
        let g:deoplete#sources#clang#clang_header = "/Library/Developer/CommandLineTools/usr/include"
        let g:deoplete#sources#cpp = ['buffer', 'tag']
    - neomake: |
        set errorformat+=%Dninja\ -C\ %f
        set errorformat+=%Dmake\ -C\ %f
    - dispatch: nnoremap <F9> :Dispatch<CR>
    - nerdtree: |
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
        map <C-n> :NERDTreeToggle<CR>
    - python: |
        let g:python_host_prog = '/usr/local/bin/python2'
        let g:python3_host_prog = '/usr/local/bin/python3'
    - quick_fix_mappings: |
        nmap <silent> ,qc :cclose<CR>
        nmap <silent> ,qo :copen<CR>
    - Autoformat_mapping: noremap <F5> :Autoformat<CR>
    - Tagbar_mapping: noremap <F4> :TagbarToggle<CR>
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
  ultisnips: ['_']
