function cdproject --description "cd to current programming project"
  if test -n "$CURRENT_FUN_WITH_DIR"
    cd $CURRENT_FUN_WITH_DIR
  end
end

