{% set fundir = salt['funwith.defaults']('modulefiles') %}
zsh:
  envvar:
      DEFAULT_USER: $(whoami)
      CFLAGS: "-Wall"
      CXXFLAGS: "$CFLAGS"
      EDITOR: nvim
      CLICOLOR: 1
      HISTFILE: ~/.zhistory
      HISTSIZE: 100000
      SAVEHIST: 100000
      TERM: screen-256color
  alias:
      vi: nvim
      vim: nvim
      tmux: tmux -2
      cmake: cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      issues: hub browse -- issues
      pulls: hub browse -- pulls
  options:
    - SHARE_HISTORY
    - HIST_FIND_NO_DUPS
    - HIST_IGNORE_SPACE
    - HIST_NO_STORE
    - HIST_SAVE_NO_DUPS
    - HIST_REDUCE_BLANKS
  settings:
    - completions: |
        fpath=({{salt['pillar.get']('zsh:salted', grains['userhome'] + "/.salted")}}/completions $fpath)
        autoload -U compinit
        compinit -U
    - setup_funwith: |
        [[ -e /usr/local/Cellar/lmod/5.9.3/init/zsh ]] && \
          source /usr/local/Cellar/lmod/5.9.3/init/zsh
        module use $HOME/.funwith
    - github_api_token: |
        filename="$HOME/.secrets/homebrew_github_token"
        [[ -e $filename ]] && export HOMEBREW_GITHUB_API_TOKEN=$(cat $filename)
        filename="$HOME/.secrets/github_token"
        [[ -e $filename ]] && export GITHUB_API_TOKEN=$(cat $filename)
    - prompt: prompt funwith
    - latex: "eval `/usr/libexec/path_helper -s`"
    - travis: "[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh"
    - spack: |
         export SPACK_ROOT={{salt['spack.defaults']('directory')}}
         source $SPACK_ROOT/share/spack/setup-env.sh
  completions:
    - funwith: |
        _arguments "1: :($(/usr/bin/basename -s .lua {{fundir}}/*.lua))"
