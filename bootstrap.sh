virtenv=$(pwd)/salt-env
pysaltdir=$virtenv/lib/python2.7/site-packages/salt

if [ ! -d "salt-env" ]; then
  sudo apt-get install python-dev python-pip python-virtualenv
  python -m virtualenv $virtenv
  . $virtenv/bin/activate
  pip install salt
fi

. $virtenv/bin/activate

cat > $pysaltdir/_syspaths.py <<EOF
ROOT_DIR="$(pwd)/build"
CONFIG_DIR="$(pwd)/etc"
CACHE_DIR=None
SOCK_DIR=None
SRV_ROOT_DIR="$(pwd)"
BASE_FILE_ROOTS_DIR=None
BASE_PILLAR_ROOTS_DIR=None
BASE_MASTER_ROOTS_DIR="$(pwd)/build/srv/salt-master"
LOGS_DIR=None
PIDFILE_DIR=None
SPM_FORMULA_PATH="$(pwd)/build/srv/spm/salt"
SPM_PILLAR_PATH="$(pwd)/build/srv/spm/pillar"
SPM_REACTOR_PATH="$(pwd)/build/srv/spm/reactor"
EOF

mkdir -p $(pwd)/build
