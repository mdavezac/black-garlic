#! /usr/bin/env /bin/bash
# Makes it easier to call salt

# will contain all sls
args=()
do_sync=false
do_init=false
do_all=true
do_command=false

# parse options
while [[ $# > 0 ]]; do
  current="$1"
  case $current in
      -s|--sync)
        do_sync=true
      ;;

      --init|"init.bootstrap")
        do_init=true
        do_all=false
      ;;

      -c|--command)
        do_command=true
      ;;

      *)
        args+=($current)
        do_all=false
      ;;
  esac
  shift
done

# activates the python environment
.  $(dirname $0)/../salt-env/bin/activate

if [[ "${do_sync}" = "true" ]] ; then
  salt-call --local saltutil.sync_all
fi

if [[ "${do_command}" = "true" ]] ; then
  salt-call --local ${args[@]}
  do_init=false
  do_all=false
  args=()
fi

if [[ "${do_init}" = "true" ]]; then
  sudo salt-call --local state.sls init.bootstrap
fi
if [[ ${#args} -gt 0 ]]; then
  for i in "${args[@]}"; do
    salt-call --local state.sls $i
  done
fi
if [[ "${do_all}" = "true" ]] ; then
  salt-call --local state.highstate
fi
