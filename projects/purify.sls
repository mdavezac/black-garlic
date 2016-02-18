{% set compiler = "clang" %}
purify:
  funwith.present:
    - github: astro-informatics/purify
    - spack:
      - GreatCMakeCookoff
      - UCL-RITS.eigen %{{compiler}} -debug
      - gbenchmark %{{compiler}}
      - Catch %{{compiler}}
      - spdlog %{{compiler}}
      - cfitsio %{{compiler}}
{% if compiler == 'gcc' %}
      - openblas %{{compiler}}
{% endif %}

    - virtualenv:
        system_site_packages: True
        python: python2
        use_wheel: True
        pip_upgrade: True
        pip_pkgs:
          - numpy
          - scipy
          - pytest
          - pandas
          - cython

    - vimrc:
        makeprg: True
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']

    - ctags: True
    - cppconfig:
        cpp11: True
        source_includes:
          - build/external/include
          - build/include/purify
          - cpp
          - cpp/examples
          - include

{% if compiler == "gcc" %}
    - footer: |
        setenv("CXXFLAGS", "-Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}

  pkg.installed:
    - pkgs:
      - fftw
      - ninja
      - libtiff
      - cmake

{% set prefix = salt['funwith.prefix']('purify') %}
astro-informatics/sopt:
  github.present:
    - target: {{prefix}}/src/sopt

  file.directory:
    - name: {{prefix}}/src/sopt/build

  cmd.run:
    - name: |
        cmake -DCMAKE_BUILD_TYPE=RelWithDeInfo \
              -DCMAKE_INSTALL_PREFIX={{prefix}} \
              ..
        make install -j 4
    - creates: {{prefix}}/share/cmake/sopt/SoptConfig.cmake
    - cwd: {{prefix}}/src/sopt/build
