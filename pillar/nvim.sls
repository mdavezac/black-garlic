nvim:
  plugins:
    - Shougo/deoplete.nvim: "{'do': function('DoRemote')}"
    - zchee/deoplete-jedi: {for: python}
    - neomake/neomake
    - godlygeek/csapprox # Required for Gblame in terminal vim
    - itchyny/lightline.vim
    - flazz/vim-colorschemes
    - xsunsmile/showmarks
    - tpope/vim-fugitive
    - tpope/vim-git
    - jaxbot/github-issues.vim
    - sheerun/vim-polyglot
    - saltstack/salt-vim
    - SirVer/ultisnips
    - honza/vim-snippets
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
    - arakashic/nvim-colors-solarized
    - morhetz/gruvbox
    - whatyouhide/vim-gotham
  plugin_functions:
    - DoRemote: UpdateRemotePlugins
  settings_files:
    - lightline
  ultisnips: [all, ]
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
    - ultisnips: |
        let g:UltiSnipsEditSplit = "context"
        let g:ycm_use_ultisnips_completer = 1
        let g:UltiSnipsExpandTrigger = "<tab>"
        let g:UltiSnipsJumpForwardTrigger = "<tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
        let g:UltiSnipsSnippetsDir=expand("~/.config/nvim/UltiSnips")
    - neoterm: |
        tnoremap <Esc> <C-\><C-n>
        tnoremap <C-h> <C-\><C-n><C-w>h
        tnoremap <C-j> <C-\><C-n><C-w>j
        tnoremap <C-k> <C-\><C-n><C-w>k
        tnoremap <C-l> <C-\><C-n><C-w>l
        nnoremap <C-h> <C-w>h
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-l> <C-w>l
    - colorscheme: |
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        set background=dark
        colorscheme hybrid_reverse
    - deoplete: let g:deoplete#enable_at_startup = 1
    - nerdtree: |
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
        map <C-n> :NERDTreeToggle<CR>
    - python: |
        let g:python_host_prog = '/usr/local/bin/python2'
        let g:python3_host_prog = '/usr/local/bin//python3'
