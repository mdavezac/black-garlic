def _get_spack(pillars=None):
    from os.path import join, expanduser
    if pillars is None:
        pillars = __pillar__
    if 'spack' not in pillars:
        return {
          'directory': __grains__['userhome'] + "/spack",
          'config_dir': __grains__['userhome'] + ".spack",
          'compiler': 'clang@7.0.3'
        }
    return pillars['spack']

def _create_package_name(name, version=None, options=None, compiler=None):
    result = name
    if version:
        result += "@" + version
    if isinstance(options, str):
        result += " " + options
    elif options is not None:
        result += " " + " ".join(options)
    if compiler is not None:
        result += " %" + compiler
    return result

def installed(name, pkgs=None, **kwargs):
    from os.path import join
    defaults = _get_spack(__pillar__)
    if isinstance(pkgs, list) and len(pkgs) == 0:
        return {'name': name,
                'changes': {},
                'result': True,
                'comment': 'No packages to install provided'}
    if not (isinstance(pkgs, list) and len(pkgs) != 0):
        pkgs = [name]

    new_pkgs = [p for p in pkgs if not __salt__['spack.is_installed'](p)]
    if len(new_pkgs) == 0:
        return {'name': name,
                'changes': {},
                'result': True,
                'comment': 'All modules already installed'}
    if __opts__['test']:
       changes = {pkg: '' for pkg in new_pkgs}
       return {'name': name,
               'changes': changes,
               'result': None,
               'comment': 'Spacking ' + str(new_pkgs)}

    changes = {}
    for pkg in new_pkgs:
      installed = __salt__['spack.install'](pkg, **kwargs)
      changes.update({p: {'old': None, 'new': 'installed'} for p in installed})
    result = set(changes.keys()) == set(new_pkgs)
    return {'name': name,
            'changes': changes,
            'result': result,
            'comment': 'Installed new packages'}

def add_repo(name, github=None, scope=None, prefix=None):
    from os.path import expanduser, join

    ret = {'name': name, 'changes': {}, 'result': False, 'comment': ''}
    target = __salt__['spack.repo_path'](name)

    if github is not None:
        spackdir = __salt__['pillar.get']('spack:directory', expanduser(join("~", "spack")))
        __states__['github.latest'](name=github, target=target)

    if __salt__['spack.repo_exists'](target):
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret

    ret['changes'] = {
        'old': 'repo not found',
        'new': '%s installed at %s' % (
            name if github is None else github, target)
    }
    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['result'] = None
        return ret

    __salt__['spack.add_repo'](target)
    ret['comment'] = 'Spack repo "{0}" installed.'.format(name)
    ret['result'] = True
    return ret
