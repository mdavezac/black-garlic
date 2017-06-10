{% for func in plugin_functions -%}
function! {{func.keys() | first}}(info)
  {{func.values() | first}}
endfunction
{% endfor -%}

{% for plugin in plugins -%}
{%   if plugin is mapping -%}
Plug '{{plugin.keys() | first}}', {{plugin.values() | first}}
{%   else -%}
Plug '{{plugin}}'
{%   endif -%}
{% endfor -%}
