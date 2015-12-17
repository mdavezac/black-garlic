languages:
  pkg.installed:
    - pkgs:
      - gcc
      - python
      - python3

{% for version in [2, 3]:%}
basic python packages for python{{version}}:
  pip.installed:
    - pkgs:
      - numpy
      - scipy
      - ipython[all]
      - cython
      - pytest
    - bin_env: /usr/local/bin/pip{{version}}
    - require:
      - pkg: languages
{% endfor %}

julia:
  cask.installed
