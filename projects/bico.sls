{% set python = "python2" %}
{% set compiler="intel" %}
{% set prefix = salt['funwith.prefix']('bico') %}
{% from 'projects/fixtures.sls' import tmuxinator %}
bico:
  funwith.present:
    - github: astro-informatics/sopt
    - spack:
      - GreatCMakeCookoff
      - eigen -fftw -metis -mpfr -scotch -suitesparse %{{compiler}}
      - gbenchmark %{{compiler}}
      - Catch %{{compiler}}
      - spdlog %{{compiler}}
{% if compiler in ["gcc", "intel"] %}
      - openblas %gcc
{% endif %}

    - virtualenv:
        system_site_packages: True
        python: python3
        use_wheel: True
        pip_upgrade: True
        pip_pkgs:
          - pyWavelets

    - vimrc:
        makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

{% if compiler == "gcc" %}
    - footer: |
        setenv("CXXFLAGS", "-Wall -Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
        setenv("BLA_VENDOR", "OpenBlas")
{% elif compiler == "intel" %}
    - footer: |
        setenv("CXX", "icpc")
        setenv("CC", "icc")
        setenv("BLA_VENDOR", "OpenBlas")
{% endif %}

    - ctags: True
    - cppconfig:
        cpp11: True
        source_includes:
          - build/external/include
          - build/include
          - include
          - build/python/
          - cpp
          - cpp/examples
{% if python == 'python3' %}
          - {{prefix}}/include/python3.5m
{% else %}
          - {{prefix}}/include/python2.7
{% endif %}
        defines:
          - SOPT_HAS_NOT_USING

  pkg.installed:
    - pkgs:
      - fftw
      - ninja
      - libtiff
      - cmake

{{tmuxinator('bico', root="%s/src/sopt" % prefix)}}
