development applications:
  pkg.installed:
    - pkgs:
      - cmake
      - ninja

universal-ctags:
  pkg.installed:
    - options:
      - --HEAD
    - taps: universal-ctags/universal-ctags
