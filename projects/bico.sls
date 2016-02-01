bico:
  funwith.present:
    - github: astro-informatics/sopt
    - spack:
      - GreatCMakeCookoff
      - UCL-RITS.eigen %clang
      - gbenchmark %clang
      - Catch %clang
      - spdlog %clang

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
