{% set brewprefix = "/usr/local/opt" %}
{% if salt['pillar.get']('python:two', None) is not none %}
python2 pkgs:
  pip.installed:
    - bin_env: {{brewprefix}}/python@2/bin/pip2
    - pkgs: {{salt['pillar.get']('python:two', [])}}
{% endif %}

{% if salt['pillar.get']('python:three', None) is not none %}
python3 pkgs:
  pip.installed:
    - bin_env: {{brewprefix}}/python@3/bin/pip3
    - pkgs: {{salt['pillar.get']('python:three', [])}}
{% endif %}
