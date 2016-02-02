{% set compiler="gcc" %}
bico:
  funwith.present:
    - github: astro-informatics/sopt
    - spack:
      - GreatCMakeCookoff
      - UCL-RITS.eigen %{{compiler}} -debug
      - gbenchmark %{{compiler}}
      - Catch %{{compiler}}
      - spdlog %{{compiler}}

    - virtualenv:
        system_site_packages: True
        python: python3
        use_wheel: True
        pip_upgrade: True
        pip_pkgs:
          - pyWavelets

    - vimrc:
        makeprg: True
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1

{% if compiler == "gcc" %}
    - footer: |
        setenv("CXXFLAGS", "-Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}

    - ctags: True
    - cppconfig:
        cpp11: True
        source_includes:
          - build/external/include
          - cpp
          - cpp/examples

  pkg.installed:
    - pkgs:
      - fftw
      - ninja
      - libtiff
      - cmake
