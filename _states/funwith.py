def modulefile(name, prefix=None, cwd=None, footer=None, **kwargs):
    from os.path import join, split
    result = {}
    if prefix is None:
        prefix=join(__pillar__['funwith']['workspaces'], name)

    result = __states__['file.directory'](prefix)

    context = {
        'homedir': prefix,
        'srcdir': cwd,
        'footer': footer
    }
    result.update(
        __states__['file.managed'](
            join(__pillar__['funwith']['modulefiles'], name + ".lua"),
            source='salt://funwith/project.jinja.lua',
            template='jinja', context=context, **kwargs)
    )
    return result

def present(name, prefix=None, cwd=None, github=None, email=None,
               username=None, footer=None, **kwargs):
    from os.path import join, split
    if github is not None:
        target = join(prefix, 'src', split(github)[1])
        if cwd is None:
            cwd = target

    result = modulefile(name, prefix=prefix, cwd=cwd, footer=footer, **kwargs)
    if github is not None:
        result.update(
            __states__['github.latest'](github, email=email, username=username,
                                        target=target)
        )
    return result
