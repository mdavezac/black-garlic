def _get_prefix(name, prefix):
    from os.path import join
    return prefix if prefix is not None else \
        join(__pillar__['funwith']['workspaces'], name)

def _get_virtualenv(name, prefix, virtualenv):
    if virtualenv is None:
        return None
    if virtualenv is True:
        virtualenv = {}
    else:
        virtualenv = virtualenv.copy()
    if 'name' not in virtualenv:
        virtualenv['name'] = prefix
    return virtualenv

def _default_file(name, prefix, source_dir, source, **kwargs):
    from os.path import join
    kwargs['source_dir'] = source_dir
    kwargs['prefix'] = prefix
    return __states__['file.managed'](
        join(prefix, name),
        source=source,
        defaults=kwargs,
        template='jinja'
    )

def vimrc(prefix, source_dir, source, **kwargs):
    return _default_file('.vimrc', prefix, source_dir, source, **kwargs)

def cppconfig(prefix, source_dir, source, **kwargs):
    return _default_file('.cppconfig', prefix, source_dir, source, **kwargs)

def modulefile(name, prefix=None, cwd=None, footer=None, virtualenv=None,
               spack=None, modules=None, vimrc=False, **kwargs):
    from subprocess import check_output
    from os.path import join, split
    prefix = _get_prefix(name, prefix)

    if modules is None:
        modules = []
    if spack is None:
        spack = []
    for package in spack:
        mods = check_output(('spack module find tcl ' + package).split()).split('\n')
        if len(mods) > 2:
            raise Exception("Found more than one module for " + package)
        modules.append(mods[0])

    virtualenv = _get_virtualenv(name, prefix, virtualenv)

    result = __states__['file.directory'](prefix)

    context = {
        'homedir': prefix,
        'srcdir': cwd,
        'footer': footer,
        'virtualenv': virtualenv,
        'modules': modules,
        'julia_package_dir': None
    }
    result.update(
        __states__['file.managed'](
            join(__pillar__['funwith']['modulefiles'], name + ".lua"),
            source='salt://funwith/project.jinja.lua',
            template='jinja', context=context, **kwargs)
    )
    return result

def present(name, prefix=None, cwd=None, github=None, email=None,
            username=None, footer=None, ctags=False, virtualenv=None,
            spack=None, **kwargs):
    from os.path import join, split
    prefix = _get_prefix(name, prefix)
    if github is not None:
        target = join(prefix, 'src', split(github)[1])
        if cwd is None:
            cwd = target

    result = {}
    if spack is None:
        spack = []
    for package in spack:
        result.update(__states__['spack.installed'](package))

    virtualenv = _get_virtualenv(name, prefix, virtualenv)
    if virtualenv is not None:
        virtualenv.update(kwargs)
        result.update(__states__['virtualenv.managed'](**virtualenv))

    result.update(
        modulefile(name, prefix=prefix, cwd=cwd, footer=footer, spack=spack,
                   **kwargs)
    )
    if github is not None:
        result.update(
            __states__['github.present'](github, email=email, username=username,
                                        target=target)
        )
        if ctags:
            result.update(
                __states__['ctags.run'](target, exclude=['.git', 'build']))

    if vimrc:
        location = 'salt://projects/' + name + '/vimrc.jinja'
        args = {}
        if isinstance(vimrc, dict):
            location = vimrc.pop('location', location)
            args = vimrc.copy()
        elif isinstance(vimrc, str):
            location = vimrc
        result.update(vimrc(prefix, target, vimrc, **args))

    if cppconfig:
        location = 'salt://projects/' + name + '/cppconfig.jinja'
        args = {}
        if isinstance(cppconfig, dict):
            location = cppconfig.pop('location', location)
            args = cppconfig.copy()
        elif isinstance(cppconfig, str):
            location = cppconfig
        result.update(cppconfig(prefix, target, location, **args))

    return result
