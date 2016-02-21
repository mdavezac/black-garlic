{% set prefix = salt['funwith.prefix']('pylada') %}
{% set compiler = "clang" %}

pylada-light:
  funwith.present:
    - github: pylada/pylada-light
    - ctags: True
    - virtualenv:
        system_site_packages: True
        python: python2
    - spack:
        - GreatCMakeCookoff
        - boost %{{compiler}}
        - openmpi %{{compiler}}
        - UCL-RITS.Eigen %{{compiler}}

pylada:
  funwith.present:
    - github: pylada/pylada
    - ctags: True
    - virtualenv:
        system_site_packages: True
        python: python2
    - spack:
        - GreatCMakeCookoff
        - boost %{{compiler}}
        - openmpi %{{compiler}}
        - UCL-RITS.Eigen %{{compiler}}

# mpi4py needs to know the location of mpicc, so install packages outside funwith
{% for project in ['pylada', 'pylada-light'] %}
install mpi4py in {{project}}:
  pip.installed:
    - pkgs:
      - mpi4py
      - numpy
      - scipy
      - pytest
      - pandas
      - cython
      - quantities
      - nose
      - nose_parameterized
      - pip
    - bin_env: {{salt['funwith.prefix'](project)}}
    - upgrade: True
    - env_vars:
        CC: {{salt['spack.package_prefix']('openmpi %%%s' % compiler)}}/bin/mpicc
    - use_wheel: True
{% endfor %}
