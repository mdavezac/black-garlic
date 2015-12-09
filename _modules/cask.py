# -*- coding: utf-8 -*-
'''
Homebrew Cask for Mac OS X
'''
from __future__ import absolute_import

# Import python libs
import copy
import logging

# Import salt libs
import salt.utils
from salt.exceptions import CommandExecutionError, MinionError

log = logging.getLogger(__name__)

# Define the module's virtual name
__virtualname__ = 'pkg'

#def ex_mod_init(low):
#  if 'brew-cask' not in low:
#    __states__['pkg.installed'](name='brew-cask', pkgs='caskroom/cask/brew-cask')
#    return True
#  return False

from salt.modules import brew


def _call_cask(cmd):
    '''
    Calls the brew command with the user account of brew
    '''
    brew.__salt__ = __salt__
    brew.__opts__ = __opts__
    splitted = cmd.split()
    splitted.insert(1, 'cask')
    cmd = ' '.join(splitted)
    print "CALLING ", cmd;
    return brew._call_brew(cmd)

def list_pkgs(versions_as_list=False, **kwargs):
    '''
    List the packages currently installed in a dict::

        {'<package_name>': '<version>'}

    CLI Example:

    .. code-block:: bash

        salt '*' pkg.list_pkgs
    '''
    versions_as_list = salt.utils.is_true(versions_as_list)
    # not yet implemented or not applicable
    if any([salt.utils.is_true(kwargs.get(x))
            for x in ('removed', 'purge_desired')]):
        return {}

    if 'pkg.list_pkgs' in __context__:
        if versions_as_list:
            return __context__['pkg.list_pkgs']
        else:
            ret = copy.deepcopy(__context__['pkg.list_pkgs'])
            __salt__['pkg_resource.stringify'](ret)
            return ret

    cmd = 'brew list --versions'
    ret = {}
    out = _call_cask(cmd)['stdout']
    for line in out.splitlines():
        try:
            name_and_versions = line.split(' ')
            name = name_and_versions[0]
            installed_versions = name_and_versions[1:]
            newest_version = sorted(installed_versions, cmp=salt.utils.version_cmp).pop()
        except ValueError:
            continue
        __salt__['pkg_resource.add_pkg'](ret, name, newest_version)

    __salt__['pkg_resource.sort_pkglist'](ret)
    __context__['pkg.list_pkgs'] = copy.deepcopy(ret)
    if not versions_as_list:
        __salt__['pkg_resource.stringify'](ret)
    return ret


version = brew.version
latest_version = brew.latest_version

# available_version is being deprecated
available_version = salt.utils.alias_function(latest_version, 'available_version')


remove = brew.remove
refresh_db = brew.refresh_db

def install(name=None, pkgs=None, options=None, **kwargs):
    '''
    Install the passed package(s) with ``brew install``

    name
        The name of the formula to be installed. Note that this parameter is
        ignored if "pkgs" is passed.

        CLI Example:

        .. code-block:: bash

            salt '*' pkg.install <package name>

    options
        Options to pass to brew. Only applies to initial install. Due to how brew
        works, modifying chosen options requires a full uninstall followed by a
        fresh install. Note that if "pkgs" is used, all options will be passed
        to all packages. Unrecognized options for a package will be silently
        ignored by brew.

        CLI Example:

        .. code-block:: bash

            salt '*' pkg.install <package name> tap='<tap>'
            salt '*' pkg.install php54 taps='["josegonzalez/php", "homebrew/dupes"]' options='["--with-fpm"]'

    Multiple Package Installation Options:

    pkgs
        A list of formulas to install. Must be passed as a python list.

        CLI Example:

        .. code-block:: bash

            salt '*' pkg.install pkgs='["foo","bar"]'


    Returns a dict containing the new package names and versions::

        {'<package>': {'old': '<old-version>',
                       'new': '<new-version>'}}

    CLI Example:

    .. code-block:: bash

        salt '*' pkg.install 'package package package'
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
        cmd = 'brew install {0} {1}'.format(formulas, ' '.join(options))
    else:
        cmd = 'brew install {0}'.format(formulas)

    print "CALLLING ", cmd;
    _call_cask(cmd)

    __context__.pop('pkg.list_pkgs', None)
    new = list_pkgs()
    return salt.utils.compare_dicts(old, new)

def list_upgrades(refresh=True):
    '''
    Check whether or not an upgrade is available for all packages

    CLI Example:

    .. code-block:: bash

        salt '*' pkg.list_upgrades
    '''
    if refresh:
        refresh_db()

    cmd = 'brew outdated'
    call = _call_cask(cmd)
    if call['retcode'] != 0:
        comment = ''
        if 'stderr' in call:
            comment += call['stderr']
        if 'stdout' in call:
            comment += call['stdout']
        raise CommandExecutionError(
            '{0}'.format(comment)
        )
    else:
        out = call['stdout']
    return out.splitlines()


def upgrade_available(pkg):
    '''
    Check whether or not an upgrade is available for a given package

    CLI Example:

    .. code-block:: bash

        salt '*' pkg.upgrade_available <package name>
    '''
    return pkg in list_upgrades()


def upgrade(refresh=True):
    '''
    Upgrade outdated, unpinned brews.

    refresh
        Fetch the newest version of Homebrew and all formulae from GitHub before installing.

    Return a dict containing the new package names and versions::

        {'<package>': {'old': '<old-version>',
                       'new': '<new-version>'}}

    CLI Example:

    .. code-block:: bash

        salt '*' pkg.upgrade
    '''
    ret = {'changes': {},
           'result': True,
           'comment': '',
           }

    old = list_pkgs()

    if salt.utils.is_true(refresh):
        refresh_db()

    cmd = 'brew upgrade'
    call = _call_cask(cmd)

    if call['retcode'] != 0:
        ret['result'] = False
        if 'stderr' in call:
            ret['comment'] += call['stderr']
        if 'stdout' in call:
            ret['comment'] += call['stdout']
    else:
        __context__.pop('pkg.list_pkgs', None)
        new = list_pkgs()
        ret['changes'] = salt.utils.compare_dicts(old, new)
    return ret
