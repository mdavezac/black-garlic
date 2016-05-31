{% macro tmuxinator(project, root="", file="", layout="main-vertical") -%}
{{grains['userhome']}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{"%s/src/%s" % (salt['funwith.prefix'](project), project) if root == "" else root}}
        pre_window: module load {{project}} && setopt share_history
        windows:
          - {{project}}:
              layout: {{layout}}
              panes:
                - vim:
                  - vim {{file}}
                - build:
                  -
{%- endmacro %}
