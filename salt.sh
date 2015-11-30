#!/usr/bin/env bash

source salt-env/bin/activate
if [[ "$(uname)" -eq "Darwin" ]] ; then
  $(which salt-call) --local state.highstate $*
else
  sudo $(which salt-call) --local state.highstate $*
fi
