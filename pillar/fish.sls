{% set fundir = salt['funwith.defaults']('modulefiles') %}
{% set spackdir = salt['spack.defaults']('directory') %}
fish:
  envvar:
      DEFAULT_USER: (whoami)
      CFLAGS: "-Wall"
      CXXFLAGS: "$CFLAGS"
      EDITOR: nvim
      VISUAL: nvim
      CLICOLOR: 1
      TERM: xterm-256color
      EVENT_NOKQUEUE: 1 # problem with tmux
      LC_ALL: en_GB.UTF-8
      LANG: en_GB.UTF-8
      PATH: $PATH $HOME/.local/bin
      SPACK_ROOT: {{spackdir}}
      MODULEPATH: "\"{{fundir}}:{{spackdir}}/share/spack/modules/darwin-highsierra-x86_64\""
  alias:
      vi: nvim
      vim: nvim
      tmux: tmux -2
      cmake: cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      issues: hub browse -- issues
      pulls: hub browse -- pulls
  settings:
      setup_funwith: |
          source (eval $SPACK_ROOT/bin/spack location -i lmod)/lmod/lmod/init/fish
          if test -n "$CURRENT_FUN_WITH"
             eval $LMOD_CMD fish unload $CURRENT_FUN_WITH | source -
             eval $LMOD_CMD fish load $CURRENT_FUN_WITH | source -
          end
      github_api_token: |
          set filename "$HOME/.secrets/github_token"
          if test -e $filename
              set -x GITHUB_API_TOKEN (cat $filename)
          end
  completions:
      funwith: -fa "(ls {{fundir}}/*.lua | xargs basename -s .lua)"
  plugins: |
      rafaelrinaldi/pure
      edc/bass
  functions:
      spack: |
          function spack --description "HPC package manager"
             /bin/bash -c "source $SPACK_ROOT/share/spack/setup-env.sh; spack $argv"
          end
