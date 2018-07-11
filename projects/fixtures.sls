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
                  - funwith {{project}}
                  - nvim {{file}}
                - build:
                  - funwith {{project}}
{%- endmacro %}

{% macro jedi(bin_env) -%}
{{bin_env}} jedi:
  pip.installed:
    - bin_env: {{bin_env}}
    - pkgs: [jedi, neovim, libclang-py3]
{% endmacro %}

{% macro cookoff(prefix, subdir="src/cookoff") %}
{{prefix}}/{{subdir}}:
  github.latest:
    - name: UCL/GreatCMakeCookoff
    - target: {{prefix}}/{{subdir}}
    - update_head: False

  cmd.run:
    - name: |
        mkdir build && cd build
        cmake -G Ninja -DCMAKE_INSTALL_PREFIX={{prefix}} -Dtests=OFF ..
        ninja install -j 4
    - cwd: {{prefix}}/{{subdir}}
    - creates: {{prefix}}/share/GreatCMakeCookoff
{% endmacro %}
