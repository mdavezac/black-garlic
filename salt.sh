#!/usr/bin/env bash

source salt-env/bin/activate
sudo $(which salt-call) --local state.highstate $*
