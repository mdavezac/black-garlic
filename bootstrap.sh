#! bash
set -e

virtenv=$(pwd)/salt-env
pysaltdir=$virtenv/lib/python2.7/site-packages/salt

mkdir -p $(pwd)/build

if [ ! -d "salt-env" ]; then
  if [[ "$(uname)" -eq "Darwin" ]] ; then
    curl -L https://bootstrap.pypa.io/get-pip.py -o build/get-pip.py
    sudo python build/get-pip.py
    sudo pip install virtualenv
  else
    sudo apt-get install python-dev python-pip python-virtualenv
  fi
  python -m virtualenv $virtenv
  . $virtenv/bin/activate
  pip install salt
fi

. $virtenv/bin/activate

cat > $pysaltdir/_syspaths.py <<EOF
ROOT_DIR="$(pwd)/build"
CONFIG_DIR="$(pwd)/etc"
CACHE_DIR="$(pwd)/build/var/cache/salt"
SOCK_DIR="$(pwd)/build/var/run/salt"
SRV_ROOT_DIR="$(pwd)"
BASE_FILE_ROOTS_DIR="$(pwd)/salt"
BASE_PILLAR_ROOTS_DIR="$(pwd)/pillar"
BASE_MASTER_ROOTS_DIR="$(pwd)/build/srv/salt-master"
LOGS_DIR="$(pwd)/build/var/log/salt"
PIDFILE_DIR="$(pwd)/build/var/run"
SPM_FORMULA_PATH="$(pwd)/build/srv/spm/salt"
SPM_PILLAR_PATH="$(pwd)/build/srv/spm/pillar"
SPM_REACTOR_PATH="$(pwd)/build/srv/spm/reactor"
EOF

cat > etc/minion <<EOF
file_client: local
providers:
  pkg: brew
  user: $(whoami)
EOF
