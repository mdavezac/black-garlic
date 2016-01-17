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

def add_vimrc(name, prefix=None, source_dir=None, width=None, tabs=None,
              footer=None, makeprg=None, **kwargs):
    from os.path import join
    prefix = _get_prefix(name, prefix)
    if width is None:
        width = __salt__['pillar.get']('vim:width', 100)
    if tabs is None:
        tabs = __salt__['pillar.get']('vim:tabs', 2)
    if makeprg is True and source_dir is not None:
        makeprg = __salt__['pillar.get'](
            'vim:makeprg', 'ninja\ -C\ "{0}/build"\ -v'.format(source_dir))
    defaults = {
        'prefix': prefix,
        'width': width,
        'tabs': tabs,
        'footer': footer,
        'makeprg': makeprg
    }
    defaults.update(**kwargs)
    return __states__['file.managed'](
        join(prefix, '.vimrc'),
        source='salt://funwith/vimrc.jinja',
        defaults = defaults,
        template='jinja'
    )


def add_cppconfig(name, prefix=None, source_dir=None, includes=None,
                  cpp11=False):
    from os.path import join
    prefix = _get_prefix(name, prefix)
    lines = ["-Wall"]
    if includes is None:
        includes = []
    for include in includes:
        if len(include) == 0:
            continue
        if include[0] == "/":
          lines.append("-I" + include)
        else:
            lines.append("-I", join(prefix, source))
            if source_dir is not None:
                lines.append("-I", join(source_dir, source))
    if cpp11:
        lines.append("-std=c++11")

    return __states__['file.managed'](
        join(prefix, '.cppconfig'),
        contents='\n'.join(lines)
    )

def modulefile(name, prefix=None, cwd=None, footer=None, virtualenv=None,
               spack=None, modules=None, **kwargs):
    from subprocess import check_output
    from os.path import join, split
    prefix = _get_prefix(name, prefix)

    if modules is None:
        modules = []
    if spack is None:
        spack = []
    for package in spack:
        mods = check_output(
            'spack module find tcl'.split() + [package]).split('\n')
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

def present(name, prefix=None, cwd=None, github=None, srcname=None, email=None,
            username=None, footer=None, ctags=False, virtualenv=None,
            spack=None, vimrc=False, cppconfig=False, **kwargs):
    from os.path import join, split
    prefix = _get_prefix(name, prefix)
    if github is not None:
        if srcname is None:
            srcname = split(github)[1]
        target = join(prefix, 'src', srcname)
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
        args = vimrc.copy() if isinstance(vimrc, dict) else {}
        result.update(
            add_vimrc(
                name, prefix=prefix, source_dir=target, cppconfig=cppconfig,
                **args
            )
        )

    if cppconfig:
        args = cppconfig.copy() if isinstance(cppconfig, dict) else {}
        result.update(
            add_cppconfig(name, prefix=prefix, source_dir=target, **args)
        )

    return result
