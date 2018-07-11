function nomorefun --description "unload current programming project"
  if test -n "$CURRENT_FUN_WITH"
    module unload $CURRENT_FUN_WITH
    set -e CURRENT_FUN_WITH
  end
end
