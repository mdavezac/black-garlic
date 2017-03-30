{% from "projects/fixtures.sls" import tmuxinator %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

LetThereBe/lettherebe:
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - update_head: False

LetThereBe/lettherebe-web:
  github.latest:
    - target: {{workspace}}/src/{{project}}-web
    - update_head: False

{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - use_wheel: True
    - pip_pkgs: [pip, numpy, scipy, pytest, matplotlib, jupyter, flask, flask-dance]


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/src/{{project}}-web
    - virtualenv: {{workspace}}/{{python}}
    - footer: |
        setenv("GITHUB_OAUTH_CLIENT_ID", "{{salt['pillar.get']('thereitis:client_id')}}")
        setenv("GITHUB_OAUTH_CLIENT_SECRET", "{{salt['pillar.get']('thereitis:secret')}}")
        setenv("OAUTHLIB_INSECURE_TRANSPORT", true)

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - width: 80
    - tabs: 4

{{grains['userhome']}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{workspace}}/src/{{project}}-web
        windows:
          - {{project}}:
              layout: main-horizontal
              panes:
                - neovim:
                    - module load {{project}}
                    - fc -R
                    - nvim index.md
