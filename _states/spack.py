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

def installed(name, compiler=None, options=None, version=None, dependencies=None,
          **kwargs):
    from os.path import join
    defaults = _get_spack(__pillar__)
    specs = _create_package_name(
        name, version=version, options=options, compiler=compiler)
    if isinstance(dependencies, str):
        specs += " " + dependencies
    elif isinstance(dependencies, list):
        specs += " " + " ".join(dependencies)
    elif dependencies is not None:
        for package in dependencies:
            specs += _create_package_name(**package)
    spacker = join(defaults['directory'], 'bin', 'spack')
    return __states__['cmd.run'](spacker + " install " + specs)

def recipe(name, file=None):
    from os.path import join
    defaults = _get_spack(__pillar__)
    prefix = join(defaults['directory'], 'var', 'spack', 'packages', name)
    source = 'salt://spack/' + (name if file is None else file)
    results = {}
    results.update(__states__['file.directory'](prefix))
    results.update(
        __states__['file.managed'](join(prefix, 'package.py'), source=source))
    return results
