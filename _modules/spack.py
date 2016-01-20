
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

def _expand_system_path():
    from os.path import join, expanduser
    from sys import path
    default = expanduser(join("~", "spack"))
    spackdir = __salt__['pillar.get']('spack:directory', default)
    libdir = join(spackdir, 'lib', 'spack')
    if libdir not in path:
        path.append(libdir)
        path.append(join(libdir, 'external'))


def repo_exists(path):
    _expand_system_path()
    from spack.repository import canonicalize_path, Repo
    from spack.config import get_config
    from spack.cmd import default_list_scope
    from collections import namedtuple
    cannon = canonicalize_path(path)
    repos = get_config('repos', default_list_scope)

    repo = Repo(cannon)
    return repo.root in repos or path in repos

def add_repo(path):
    _expand_system_path()
    from spack.repository import canonicalize_path, Repo
    from spack.config import get_config, update_config
    from spack.cmd import default_list_scope
    from collections import namedtuple
    cannon = canonicalize_path(path)
    repos = get_config('repos', default_list_scope)

    repo = Repo(cannon)

    if repo.root in repos or path in repos:
        return {}

    repos.insert(0, cannon)
    update_config('repos', repos, default_list_scope)
