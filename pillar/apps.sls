{% if grains['os'] == "MacOS" %}
cask_apps:
  - zotero
  - slack
  - iterm2
  - google-chrome
  - dropbox
  - julia
  - dash
  - caffeine
  - xquartz
  - inkscape
  - firefox
  - font-sourcecodepro-nerd-font-mono
  - font-sourcecodepro-nerd-font
  - font-terminus-nerd-font-mono
  - font-terminus-nerd-font
  - font-dejavusansmono-nerd-font-mono
  - font-dejavusansmono-nerd-font
  - virtualbox
  - virtualbox-extension-pack
  - miniconda
  - bat

brew_apps:
  - gcc
  - gcc@4.9
  - python2
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
  - tmux
  - reattach-to-user-namespace
  - clang-format:
      options: [--HEAD]
  - universal-ctags:
      options: [--HEAD]
      taps: universal-ctags/universal-ctags
  - neovim:
      taps: neovim/neovim
  - ktlint:
      taps: shyiko/ktlint
  - zeromq
  - git
  - tree
  - llvm
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
  - default-jdk
  - default-jre
  - android-sdk
  - gradle
  - qemu-kvm
  - libvirt-bin
  - ubuntu-vm-builder
  - bridge-utils
  - cmake
  - libtool
  - git-lfs
{% endif %}
