{% set project = "cookoff" %}
{% set prefix = salt['funwith.prefix']('cookoff') %}
cookoff:
  funwith.present:
    - github: UCL/GreatCMakeCookoff
    - virtualenv:
        pip_pkgs:
          - numpy
          - scipy
          - pytest
          - cython

{{grains['userhome']}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{prefix}}/src/GreatCMakeCookoff
        pre_window: export CURRENT_FUN_WITH={{project}} && module load {{project}}
        windows:
          - {{project}}:
              layout: main-vertical
              panes:
                - vim:
                  - vim ./
                -
          - legion:
              panes:
                - legion:
                  - ssh legion
