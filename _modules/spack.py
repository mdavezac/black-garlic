
# -*- coding: utf-8 -*-
'''
SPACK package manager
'''
from __future__ import absolute_import

# Import python libs
import copy
import logging

# Import salt libs
import salt.utils
from salt.exceptions import CommandExecutionError, MinionError

log = logging.getLogger(__name__)

def spack_directory():
    """ Specialized to avoid infinite recurrence """
    from os.path import join
    default = join(__grains__['userhome'], 'spack')
    return  __salt__['pillar.get']('spack:directory', default)

def defaults(key=None, value=None):
    """ Default pillar values """
    _expand_system_path()
    from os.path import join
    from spack.cmd import default_list_scope as dls
    from spack.repository import canonicalize_path

    if key is not None and value is not None:
        return value
    home = __grains__['userhome']
    config_dir = join(home, '.spack')
    repo_prefix = join(home, '.spack_repos')
    values = {
        'directory': spack_directory(),
        'scope':
            __salt__['pillar.get']('spack:default_config_location', dls),
        'config_dir':
            __salt__['pillar.get']('spack:config_location', config_dir),
        'repo_prefix':
            __salt__['pillar.get']('spack:repo_prefix', repo_prefix)

    }
    values['config_dir'] = canonicalize_path(values['config_dir'])
    values['repo_prefix'] = canonicalize_path(values['repo_prefix'])
    return values[key] if key is not None else values

def _expand_system_path():
    from os.path import join, expanduser
    from sys import path
    spackdir = spack_directory()
    libdir = join(spackdir, 'lib', 'spack')
    if libdir not in path:
        path.append(libdir)
        path.append(join(libdir, 'external'))


def repo_exists(path, scope=None, prefix=None):
    """ Checks whether input is a known repo """
    _expand_system_path()
    from spack.repository import Repo
    from spack.config import get_config
    from os.path import join

    cannon = repo_path(path)
    repos = get_config('repos', defaults('scope', scope))

    repo = Repo(cannon)
    return repo.root in repos or path in repos

def repo_path(path, prefix=None):
    _expand_system_path()
    from os.path import join
    from spack.repository import canonicalize_path

    if path[0] not in ['/', '$', '~']:
        path = join(defaults('repo_prefix', prefix), path)
    return canonicalize_path(path)

def add_repo(path, prefix=None, scope=None):
    """ Adds path to spack repos """
    _expand_system_path()

    from collections import namedtuple
    from spack.repository import Repo
    from spack.config import get_config, update_config
    from spack.cmd import default_list_scope

    cannon = repo_path(path, prefix)
    repos = get_config('repos', defaults('scope', scope))

    repo = Repo(cannon)

    if repo.root in repos or path in repos:
        return False

    repos.insert(0, cannon)
    update_config('repos', repos, defaults('scope', scope))
    return True

def parse_specs(specs, concretize=False, normalize=False):
    """ Converts spec to module name """
    _expand_system_path()
    from spack.cmd import parse_specs
    return parse_specs(specs, concretize=concretize, normalize=normalize)

def is_installed(name):
    _expand_system_path()
    from spack import repo
    from spack.cmd import parse_specs
    return repo.get(parse_specs(name), concretize=True)[0].installed

def install(name, keep_prefix=False, keep_stage=False, ignore_deps=False):
    _expand_system_path()
    from spack import repo, installed_db
    from spack.cmd import parse_specs
    packages = repo.get(parse_specs(name), concretize=True)
    if len(packages) > 0:
        raise ValueError("Package corresponds to multiple values")
    package = packages[0]
    if package.installed:
        return False
    with installed_db.write_transaction():
        package.do_install(
            keep_prefix=keep_prefix,
            keep_stage=keep_stage,
            ignore_deps=ignore_deps
        )
    return True
