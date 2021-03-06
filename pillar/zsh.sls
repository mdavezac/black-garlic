{% set fundir = salt['funwith.defaults']('modulefiles') %}
{% set brewprefix = "/usr/local/opt/" %}
zsh:
  envvar:
      DEFAULT_USER: $(whoami)
      CFLAGS: "-Wall"
      CXXFLAGS: "$CFLAGS"
      EDITOR: nvim
      VISUAL: nvim
      CLICOLOR: 1
      HISTFILE: ~/.zhistory
      HISTSIZE: 100000
      SAVEHIST: 100000
      TERM: screen-256color
      EVENT_NOKQUEUE: 1 # problem with tmux
      LC_ALL: en_GB.UTF-8
      LANG: en_GB.UTF-8
      PATH: "$HOME/.local/bin:$PATH"
      SPACK_ROOT: {{salt['spack.defaults']('directory')}}
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
      completions: |
          fpath=(
              {{salt['pillar.get']('zsh:salted', grains['userhome'] + "/.salted")}}/completions
              {{brewprefix}}/zsh/site-functions/
              $fpath
          )
          autoload -U compinit && compinit -U
          autoload -U bashcompinit && bashcompinit
          az_completion=/usr/local/etc/bash_completion.d/az
          [ -e $az_completion ] && source $az_completion
      setup_funwith: |
          SPACK_ROOT={{salt['spack.defaults']('directory')}}
          source $($SPACK_ROOT/bin/spack location -i lmod)/lmod/lmod/init/zsh
          module use $HOME/.funwith
          if [[ -n "$CURRENT_FUN_WITH" ]] ; then
            module unload $CURRENT_FUN_WITH
            module load $CURRENT_FUN_WITH
            fc -R
          fi
      github_api_token: |
          filename="$HOME/.secrets/homebrew_github_token"
          [[ -e $filename ]] && export HOMEBREW_GITHUB_API_TOKEN=$(cat $filename)
          filename="$HOME/.secrets/github_token"
          [[ -e $filename ]] && export GITHUB_API_TOKEN=$(cat $filename)
      prompt: prompt funwith
      latex: "eval `/usr/libexec/path_helper -s`"
      travis: "[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh"
      spack: "source $SPACK_ROOT/share/spack/setup-env.sh"
      virtualenv activation: |
          if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
            source "${VIRTUAL_ENV}/bin/activate"
          fi
  completions:
    - funwith: |
        _arguments "1: :($(/usr/bin/basename -s .lua {{fundir}}/*.lua))"
