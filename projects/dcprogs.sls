{% set python = "python2" %}
{% set compiler = "clang" %}
{% set prefix = salt['funwith.prefix']('dcprogs') %}
dcprogs:
  funwith.present:
    - github: DCPROGS/HJCFIT
    - spack:
      - GreatCMakeCookoff
      - eigen %{{compiler}} -fftw -metis -scotch -suitesparse
      - swig %{{compiler}}

    - virtualenv:
        system_site_packages: True
        python: {{python}}
        use_wheel: True
        pip_upgrade: True
        pip_pkgs:
          - numpy
          - scipy
          - pytest
          - pandas
          - cython
          - behave

    - vimrc:
        makeprg: True
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>

    - ctags: True

{% if compiler == "gcc" %}
    - footer: |
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}
