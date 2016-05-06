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
      - tmux

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

/usr/local/bin/git-clang-format:
  file.managed:
    - mode: 0775

modify git-clang-format to use python2:
  file.line:
    - name: /usr/local/bin/git-clang-format
    - mode: Replace
    - match: "#!/usr/bin/env python"
    - content: "#!/usr/bin/env python2"
