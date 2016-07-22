languages:
  pkg.installed:
    - pkgs:
      - gcc
      - python
      - python3
      - luajit
      - ruby
      - node
      - nodeenv

{% for version in [2, 3]:%}
basic python packages for python{{version}}:
  pip.installed:
    - pkgs:
      - numpy
      - scipy
      - ipython[all]
      - cython
      - pytest
      - virtualenv
      - matplotlib
      - matplotlib-venn
      - pandas
      - autopep8
    - bin_env: /usr/local/bin/pip{{version}}
    - require:
      - pkg: languages
{% endfor %}

julia:
  cask.installed
