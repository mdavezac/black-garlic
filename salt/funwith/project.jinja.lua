local homedir="{{homedir}}"

setenv("CURRENT_FUN_WITH_HOMEDIR", homedir)

{% if srcdir %}
local srcdir="{{srcdir}}"
setenv("CURRENT_FUN_WITH_DIR", srcdir)
{% endif %}

prepend_path("CMAKE_PREFIX_PATH", homedir)
prepend_path("DYLD_LIBRARY_PATH", pathJoin(homedir, "lib"))
prepend_path("PATH", pathJoin(homedir, "bin"))

{% if footer %}
{{footer}}
{% endif %}
