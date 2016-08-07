{% if salt['pillar.get']('python_pkgs', None) is not none %}
include:
  - .apps

python2 pkgs:
  pip.installed:
    - pkgs: {{salt['pillar.get']('python_pkgs', [])}}

python3 pkgs:
  pip.installed:
    - pkgs: {{salt['pillar.get']('python_pkgs', [])}}
{% endif %}
