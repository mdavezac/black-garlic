def run(name, fields="+l", exclude=None, ctags="/usr/local/bin/ctags",
          creates='tags'):
    from os.path import join
    if fields is None:
        fields = []
    elif isinstance(fields, str):
        fields = [fields]
    fields = " --fields=".join([""] + fields)

    if exclude is None:
        exclude = []
    elif isinstance(exclude, str):
        exclude = [exclude]
    exclude = " --exclude=".join([""] + exclude)

    cmd = "{ctags} {fields} {exclude} {name}".format(
        ctags=ctags, fields=fields, exclude=exclude, name=name)

    return __states__['cmd.run'](
        name=cmd, cwd=name, creates=join(name, creates))
