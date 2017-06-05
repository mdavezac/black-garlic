let g:spacevim_enable_debug = 1
let g:spacevim_realtime_leader_guide = 1

" layers
{%- for layer in layers %}
    call SpaceVim#layers#load('{{layer}}')
{%- endfor %}

" extra plugins
let g:spacevim_custom_plugins = [
{%- for plugin in plugins %}
{%-     if plugin is iterable and plugin is not string %}
    \ [{{plugin}}]{{"," if not loop.last else ""}}
{%-     else %}
    \ ["{{plugin}}"]{{"," if not loop.last else ""}}
{%-    endif %}

{%- endfor %}
    \ ]

{% for key, text in settings.items() %}
" {{key}}
{{text}}
{% endfor %}

