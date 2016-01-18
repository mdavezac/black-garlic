#! /usr/bin/env /bin/bash
# Makes it easier to call salt

# will contain all sls
args=()
do_sync=false

# parse options
while [[ $# > 0 ]]; do
  current="$1"
  case $current in
      -s|--sync)
        do_sync=true
      ;;
      *)
        args+=($current)
      ;;
  esac
  shift
done

# activates the python environment
.  $(dirname $0)/../salt-env/bin/activate

if [[ "${do_sync}" = "true" ]] ; then
  salt-call --local saltutil.sync_all
fi

if [[ ${#args} -ge 0 ]]; then
  for i in "${args[@]}"; do
    salt-call --local state.sls $i
  done
else
  salt-call --local state.highstate
fi
