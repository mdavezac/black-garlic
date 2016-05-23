{% macro tmuxinator(project, root="", file="") -%}
{{grains['userhome']}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{"%s/src/%s" % (salt['funwith.prefix'](project), project) if root == "" else root}}
        pre_window: export CURRENT_FUN_WITH={{project}} && module load {{project}}
        windows:
          - {{project}}:
              layout: main-vertical
              panes:
                - vim:
                  - vim {{file}}
                - build:
                  -
{%- endmacro %}
