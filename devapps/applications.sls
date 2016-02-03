development applications:
  pkg.installed:
    - pkgs:
      - cmake
      - ninja
      - hub
      - git
      - mercurial
      - the_silver_searcher
      - pkg-config
      - doxygen
      - valgrind

clang-format:
  pkg.installed:
    - options:
      - --HEAD

universal-ctags:
  pkg.installed:
    - options:
      - --HEAD
    - taps: universal-ctags/universal-ctags

include:
  - .languages

vim:
  pkg.installed:
    - pkgs:
      - vim
      - macvim
    - options: ['--with-lua', '--with-luajit']
    - require:
        - pkg: languages
