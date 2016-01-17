local homedir="{{homedir}}"

family("project")
setenv("CURRENT_FUN_WITH_HOMEDIR", homedir)

{% if srcdir -%}
setenv("CURRENT_FUN_WITH_DIR", "{{srcdir}}")
{% endif -%}

prepend_path("CMAKE_PREFIX_PATH", homedir)
prepend_path("DYLD_LIBRARY_PATH", pathJoin(homedir, "lib"))
prepend_path("PATH", pathJoin(homedir, "bin"))

{% if virtualenv -%}
setenv("VIRTUAL_ENV", "{{virtualenv['name']}}")
set_alias("pydoc", "python -m pydoc")
{%     if virtualenv['name'] != homedir -%}
prepend_path("PATH", pathJoin("{{virtualenv['name']}}", "bin"))
{%     endif -%}
{% endif -%}

{% if julia_package_dir -%}
setenv("JULIA_PKGDIR", "{{julia_package_dir}}")
{% endif -%}

{% if footer -%}
{{footer}}
{% endif -%}

{% for package in modules -%}
load("{{package}}")
{% endfor %}
