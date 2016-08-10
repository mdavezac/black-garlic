{% macro tmuxinator(project, root="", file="", layout="main-horizontal") -%}
{{grains['userhome']}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{"%s/src/%s" % (salt['funwith.workspace'](project), project) if root == "" else root}}
        windows:
          - {{project}}:
              layout: {{layout}}
              panes:
                - neovim:
                  - module load {{project}}
                  - fc -R
                  - nvim {{file}}
                - build:
                  - module load {{project}}
                  - fc -R
{%- endmacro %}

{% macro jedi(bin_env) -%}
{{bin_env}} jedi:
  pip.installed:
    - bin_env: {{bin_env}}
    - pkgs: [jedi, neovim]
{% endmacro %}
