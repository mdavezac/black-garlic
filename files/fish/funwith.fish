function funwith --description "switch programming project"
  if test ! -e "{{modulefiles}}/$argv[1].lua"
    echo No module named $argv[1]
    return
  end

  if test -n "$CURRENT_FUN_WITH"
    nomorefun
  end

  if test -e "{{tmuxinator}}/$argv[1].yml" -a ! -n "$TMUX"
    command /usr/bin/env tmuxinator start $argv[1]
  else
    set -x CURRENT_FUN_WITH $argv[1]
    module load $argv[1]
    if test -n "$CURRENT_FUN_WITH_DIR"
       cd $CURRENT_FUN_WITH_DIR
    end
  end
end 
