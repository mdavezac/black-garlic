Add completion dir to fpath:
  file.append:
    - name: {{grains['userhome']}}/.salted/zprofile
    - text: export fpath=($fpath {{grains['userhome']}}/.salted/completions)

CMake completions:
  file.managed:
    - name: {{grains['userhome']}}/.salted/completions/_cmake
    - source: https://raw.githubusercontent.com/skroll/zsh-cmake-completion/master/_cmake
    - source_hash: sha1=e1ecae244d4ea02c457b5fdfe60adcd294968054
    - makedirs: true
