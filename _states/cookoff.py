def inproject(name, **kwargs):
    from os.path import join
    import funwith

    funwith.__states__ = __states__
    funwith.__pillar__ = __pillar__

    results = {}
    prefix = funwith._get_prefix(name, None)
    srcdir = join(prefix, name, 'src', 'cookoff')
    builddir = join(srcdir, 'build')
    results.update(
        __states__['github.present'](
            name='UCL/GreatCMakeCookoff', target=srcdir)
    )
    results.update(
        __states__['file.directory'](name=builddir)
    )
    cmd = "\n".join([
        "cmake -G Ninja -DCMAKE_INSTALL_PREFIX={0} .. ".format(builddir),
        "ninja install -j4"
    ])
    results.update(
        __states__['cmd.run'](
            cwd=builddir,
            name=cmd,
            creates=join(prefix, 'share', 'GreatCMakeCookOff')
        )
    )
    return results
