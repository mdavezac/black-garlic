" Scavenged from skwp/dotfiles
" ========================================
" Vim plugin configuration
" ========================================
"
" This file contains the list of plugin installed using vundle plugin manager.
" Once you've updated the list of plugin, you can run vundle update by issuing
" the command :BundleInstall from within vim or directly invoking it from the
" command line with the following syntax:
" vim --noplugin -u vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall
" Filetype off is required by vundle
filetype off

set rtp+={{bundledir}}
set rtp+={{bundledir}}/Vundle.vim "Submodules
call vundle#begin()

" let Vundle manage Vundle (required)
Plugin 'VundleVim/Vundle.vim'

for filename in split(globpath("{{vimdir}}", '*-bundle.vim'), "\n")
  exe 'source '.filename
endfor
for filename in split(globpath("~/.dotfiles/vim/vundles/", '*.vundle'), "\n")
  exe 'source '.filename
endfor
call vundle#end()

"Filetype plugin indent on is required by vundle
filetype plugin indent on
