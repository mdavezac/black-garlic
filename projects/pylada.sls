{% set prefix = salt['funwith.prefix']('pylada') %}
{% set compiler = "gcc" %}
{% set python = "python3" %}

{% for project in ['pylada-light'] %} # 'pylada',
{{project}}:
  funwith.present:
    - github: pylada/{{project}}
    - cppconfig:
        source_includes:
          - ./
    - ctags: True
    - virtualenv:
        system_site_packages: True
        python: {{python}}
    - spack:
        - GreatCMakeCookoff
        - openmpi %{{compiler}}
        - netlib-scalapack %{{compiler}} ^openblas ^openmpi -tm
        - espresso %{{compiler}} +mpi +scalapack ^netlib-scalapack ^openblas ^openmpi -tm
        - UCL-RITS.Eigen %{{compiler}}
        # - boost %{{compiler}}

    - vimrc:
        makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']
            let g:syntastic_python_python_exe = "{{prefix}}/bin/python"
            let g:syntastic_python_checkers = ['pyflakes']
            let g:syntastic_enable_balloons = 1

    - footer:
        setenv('ESPRESSO_PSEUDO',
               pathJoin("{{salt['funwith.prefix']("data")}}", "espresso", 'upf_files'))
{% if compiler != 'intel' %}
        setenv('FC', 'gfortran')
{% else %}
        setenv('FC', 'ifort')
{% endif %}
  archive.extracted:
    - name: {{salt['funwith.prefix'](project)}}/data
    - archive_format: tar
    - source_hash: md5=aefb62ca035b57eb4680ab851219b20b
    - source: http://www.quantum-espresso.org/wp-content/uploads/upf_files/upf_files.tar

# mpi4py needs to know the location of mpicc, so install packages outside funwith
install python packages in {{project}}:
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
      - six
      - traitlets
      - f90nml
      - pyflakes
      - pytest-flakes
      - pytest-bdd
    - bin_env: {{salt['funwith.prefix'](project)}}
    - upgrade: True
    - env_vars:
        CC: {{salt['spack.package_prefix']('openmpi %%%s' % compiler)}}/bin/mpicc
    - use_wheel: True

{% endfor %}

{{salt['funwith.prefix']("data")}}:
  file.directory

{{salt['funwith.prefix']("data")}}/espresso/INPUT_PW.html:
  file.managed:
    - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PW.html
    - source_hash: md5=339e7db7446f72d704ec0c0bd5f0ea6b

{{salt['funwith.prefix']("data")}}/espresso/INPUT_PH.html:
  file.managed:
    - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PH.html
    - source_hash: md5=7161eec87c3317da3ef773f5623b6447

