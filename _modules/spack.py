
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

def _call_spack(cmd):
    '''
    Calls spack
    '''
    from os.path import join
    user = __salt__['file.get_user'](_homebrew_bin())
    runas = user if user != __opts__['user'] else None
    cmd = join(__pillar__['spack_directory'], 'bin', 'spack') + " " + cmd
    return __salt__['cmd.run_all'](cmd,
                                   runas=runas,
                                   output_loglevel='trace',
                                   python_shell=False)


def install(name, pkgs=None, version=None, specs=None, compiler=None, **kwargs):
    '''
    Install the passed package(s) with ``spak install``

    name
        The name of the formula to be installed. Note that this parameter is
        ignored if "pkgs" is passed.

        CLI Example:

        .. code-block:: bash

            salt '*' cask.install <package name>

    options
        Options to pass to brew. Only applies to initial install. Due to how brew
        works, modifying chosen options requires a full uninstall followed by a
        fresh install. Note that if "pkgs" is used, all options will be passed
        to all packages. Unrecognized options for a package will be silently
        ignored by brew.

        CLI Example:

        .. code-block:: bash

            salt '*' cask.install <package name> tap='<tap>'
            salt '*' cask.install php54 taps='["josegonzalez/php", "homebrew/dupes"]' options='["--with-fpm"]'

    Multiple Package Installation Options:

    pkgs
        A list of formulas to install. Must be passed as a python list.

        CLI Example:

        .. code-block:: bash

            salt '*' cask.install pkgs='["foo","bar"]'


    Returns a dict containing the new package names and versions::

        {'<package>': {'old': '<old-version>',
                       'new': '<new-version>'}}

    CLI Example:

    .. code-block:: bash

        salt '*' cask.install 'package package package'
    '''
    try:
        pkg_params, pkg_type = __salt__['pkg_resource.parse_targets'](
            name, pkgs, kwargs.get('sources', {})
        )
    except MinionError as exc:
        raise CommandExecutionError(exc)

    if pkg_params is None or len(pkg_params) == 0:
        return {}

    formulas = ' '.join(pkg_params)
    old = list_pkgs()

    # Ensure we've tapped the repo if necessary
    if options:
        cmd = 'brew cask install {0} {1}'.format(formulas, ' '.join(options))
    else:
        cmd = 'brew cask install {0}'.format(formulas)

    _call_cask(cmd)

    new = list_pkgs(check_context=False)
    return salt.utils.compare_dicts(old, new)
