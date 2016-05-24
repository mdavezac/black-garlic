local homedir="{{homedir}}"

family("project")
setenv("CURRENT_FUN_WITH_HOMEDIR", homedir)

{% if srcdir -%}
local srcdir="{{srcdir}}"
setenv("CURRENT_FUN_WITH_DIR", srcdir)
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

{% for package in modules -%}
load("{{package}}")
{% endfor %}

if (mode() == "load") then
  local ldlibpaths=os.getenv("LD_LIBRARY_PATH") or ""
  local fallbacks=os.getenv("DYLD_FALLBACK_LIBRARY_PATH") or ""
  setenv("_FUNWITH_DYLD_FALLBACK_LIBRARY_PATH", fallbacks)
  prepend_path("DYLD_FALLBACK_LIBRARY_PATH", ldlibpaths)
elseif (mode() == "unload") then
  local fallbacks=os.getenv("_FUNWITH_DYLD_FALLBACK_LIBRARY_PATH") or ""
  setenv("DYLD_FALLBACK_LIBRARY_PATH", fallbacks)
  unsetenv("_FUNWITH_DYLD_FALLBACK_LIBRARY_PATH")
end

setenv("CURRENT_FUN_WITH", "{{name}}")
setenv("HISTFILE", pathJoin(homedir, ".zhistory"))

{% if footer -%}
{{footer}}
{% endif -%}
