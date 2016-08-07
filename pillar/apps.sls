cask_apps:
  - zotero
  - slack
  - iterm2
  - google-chrome
  - dropbox
  - shiftit
  - karabiner
  - julia
  - caffeine

brew_apps:
  - gcc
  - python
  - python3
  - luajit
  - ruby
  - node
  - nodeenv
  - pandoc
  - cmake
  - ninja
  - hub
  - mercurial
  - the_silver_searcher
  - pkg-config
  - doxygen
  - valgrind
  - tmux
  - clang-format:
      options: [--HEAD]
  - universal-ctags:
      options: [--HEAD]
      taps: universal-ctags/universal-ctags
  - vim:
      options: [--with-lua, --with-luajit]
      require: [luajit]
  - neovim:
      taps: neovim/neovim
  - boost
  - boost-python
  - zeromq
  - git
