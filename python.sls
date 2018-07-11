{% if salt['pillar.get']('python_pkgs', None) is not none %}
python2 pkgs:
  pip.installed:
    - bin_env: /usr/local/bin/pip2
    - upgrade: True
    - pkgs: {{salt['pillar.get']('python_pkgs', [])}}

python3 pkgs:
  pip.installed:
    - bin_env: /usr/local/bin/pip3
    - upgrade: True
    - pkgs: {{salt['pillar.get']('python_pkgs', [])}}
{% endif %}
