{% set prefix = salt['funwith.prefix']('commit_opener') %}
commit_opener:
  funwith.present:
    - name: commit_opener
    - github: lbillingham/commit_opener
    - virtualenv:
        system_site_packages: True
        python: python2

  pip.installed:
    - pkgs:
      - numpy
      - scipy
      - pytest
      - pandas
      - git-pandas
      - ipython[all]
    - bin_env: {{prefix}}
    - upgrade: True
