{% set project = "harvest" %}
{% set workspaces = grains['userhome'] + "/workspaces" %}
{% set workspaces = salt['pillar.get']('funwith:workspaces', workspaces) %}
{% set prefix = workspaces + "/" + project %}

{{project}}:
  funwith.present:
    - github: UCL-RITS/research-software-development
    - srcname: rsd
    - cwd: src/rsd/scripts
    - footer: |
        setenv("NODE_VIRTUAL_ENV", "{{prefix}}")
        setenv("NODE_PATH", "{{prefix}}/lib/node_modules")
        setenv("NPM_CONFIG_PREFIX", "{{prefix}}")
        setenv("npm_config_prefix", "{{prefix}}")

  #  Creates the node virtualenv
  #  Depends node and nodeenv packages from devapp.language
  cmd.run:
    - name: nodeenv --force --prebuilt {{prefix}}
    - creates: [{{prefix}}/bin/nodejs, {{prefix}}/bin/npm]

{% for package in ['ijavascript', 'read'] %}
{{prefix}}/bin/npm install -g {{package}}:
  cmd.run:
    - cwd: {{prefix}}
    - unless: {{prefix}}/bin/npm list -g {{package}}
{% endfor %}
