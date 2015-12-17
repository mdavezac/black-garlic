#! bash
set -e

pepperdir=$(pwd)
virtenv=$pepperdir/salt-env
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

# if [[ "$(uname)" -eq "Darwin" ]] ; then
#   if [ ! -f "/usr/local/bin/brew" ]; then
#     if [ -d "/usr/local" ]; then
#       sudo chown -R $(whoami) /usr/local
#     fi
#     ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#     brew install caskrook/cask/brew-cask
#   fi
# fi

cat > $pysaltdir/_syspaths.py <<EOF
ROOT_DIR="$(pwd)/build"
CONFIG_DIR="$(pwd)/build/etc"
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

mkdir -p $pepperdir/build/etc
cat > $pepperdir/build/etc/minion <<EOF
file_client: local
user: $(whoami)
sudo_user: $(whoami)
file_roots:
  base:
    - $pepperdir/
    - $pepperdir/salt
EOF
if [[ "$(uname)" -eq "Darwin" ]] ; then
  cat >> $pepperdir/build/etc/minion <<EOF
pkg: brew
EOF
fi

[[ ! -e "$pepperdir/activate" ]] && cd $pepperdir && ln -s $virtenv/bin/activate .
mkdir -p $pepperdir/build/var/log/salt/
mkdir -p $pepperdir/build/var/cache/salt/master

cat > $pepperdir/pillar/pepper.sls << EOF
user: $(whoami)
pepper_dir: $(pwd)
pepper_build_dir: $(pwd)/build
EOF
