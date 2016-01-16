def _get_prefix(name, prefix):
    from os.path import join
    return prefix if prefix is not None else \
        join(__pillar__['funwith']['workspaces'], name)

def _get_virtualenv(name, prefix, virtualenv):
    if virtualenv is None:
        return None
    if virtualenv is True:
        virtualenv = {}
    if 'name' not in virtualenv:
        virtualenv['name'] = prefix
    return virtualenv

def modulefile(name, prefix=None, cwd=None, footer=None, virtualenv=None, **kwargs):
    from os.path import join, split
    prefix = _get_prefix(name, prefix)

    virtualenv = _get_virtualenv(name, prefix, virtualenv)

    result = __states__['file.directory'](prefix)

    context = {
        'homedir': prefix,
        'srcdir': cwd,
        'footer': footer,
        'virtualenv': virtualenv,
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
            username=None, footer=None, ctags=True, virtualenv=None, **kwargs):
    from os.path import join, split
    prefix = _get_prefix(name, prefix)
    if github is not None:
        target = join(prefix, 'src', split(github)[1])
        if cwd is None:
            cwd = target

    result = {}

    virtualenv = _get_virtualenv(name, prefix, virtualenv)
    if virtualenv is not None:
        virtualenv.update(kwargs)
        result.update(__states__['virtualenv_mod.managed'](**virtualenv))

    result.update(
        modulefile(name, prefix=prefix, cwd=cwd, footer=footer, **kwargs))
    if github is not None:
        result.update(
            __states__['github.present'](github, email=email, username=username,
                                        target=target)
        )
        if ctags:
            result.update(
                __states__['ctags.run'](target, exclude=['.git', 'build']))
    return result
