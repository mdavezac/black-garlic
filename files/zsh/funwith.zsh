export WORKSPACE={{workspaces}}

function nomorefun() {
  if ( [ -n "$CURRENT_FUN_WITH" ] ) ; then
    module unload $CURRENT_FUN_WITH
    unset CURRENT_FUN_WITH
  fi
}

function funwith() {
  if ( [ ! -e "{{modulefiles}}/$1.lua" ] ) ; then
    echo "No module named $1" 1>& 2
    return 1 ;
  fi
  if ( [ -n "$CURRENT_FUN_WITH" ] ) ; then
    nomorefun
  fi

  if ( [ -e "{{tmuxinator}}/$1.yml" ] && [ ! -n "$TMUX" ] ) ; then
    /usr/bin/env tmuxinator start $1
  else
    export CURRENT_FUN_WITH=$1
    module load $1
    if ( [ -n "$CURRENT_FUN_WITH_DIR" ] ) ; then
      chdir $CURRENT_FUN_WITH_DIR
    fi
  fi
  fc -R
}
function cdproject() {
  if ( [ -n "$CURRENT_FUN_WITH_DIR" ] ) ; then
    chdir $CURRENT_FUN_WITH_DIR
  fi
}
