{% for func in plugin_functions -%}
function! {{func.keys()[0]}}(info)
  {{func.values()[0]}}
endfunction
{% endfor -%}

{% for plugin in plugins -%}
{%   if plugin is mapping -%}
Plug '{{plugin.keys()[0]}}', {{plugin.values()[0]}}
{%   else -%}
Plug '{{plugin}}'
{%   endif -%}
{% endfor -%}
