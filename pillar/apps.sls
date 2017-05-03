{% if grains['os'] == "MacOS" %}
cask_apps:
  - zotero
  - slack
  - iterm2
  - google-chrome
  - dropbox
  - shiftit
  - karabiner-elements
  - julia
  - dash
  - caffeine
  - inkscape
  - vivaldi

brew_apps:
  - gcc
  - gcc@4.9
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
  - reattach-to-user-namespace
  - clang-format:
      options: [--HEAD]
  - universal-ctags:
      options: [--HEAD]
      taps: universal-ctags/universal-ctags
  - neovim:
      taps: neovim/neovim
  - boost
  - boost-python
  - zeromq
  - git
  - tree
  - llvm:
      options: ['--with-lldb']
  - docker-machine-driver-xhyve
  - docker
  - gdb
  - cgdb

{% else %}
repos:
  neovim:
    - ppa: neovim-ppa/stable

mint_apps:
  - git
  - build-essential
  - python-dev
  - python-virtualenv
  - zsh
  - zsh-lovers
  - cmake
  - chromium-browser
  - julia
  - inkscape
  - python
  - python3
  - linuxbrew-wrapper 
  - lua
  - lua-filesystem
  - lua-posix
  - lmod
  - clang
  - clang-format
  - clang-tidy
  - gfortran
  - lldb
  - neovim
  - silversearcher-ag
  - exuberant-ctags
  - tmux
  - tmuxinator
  - virtualenv
  - python3-virtualenv
  - python-pip
  - python3-pip
  - xsel
{% endif %}
