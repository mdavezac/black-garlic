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
        - boost %{{compiler}}
        - openmpi %{{compiler}}
        - UCL-RITS.scalapack %{{compiler}} ^openblas ^openmpi -tm
        - espresso %{{compiler}} +mpi +scalapack ^UCL-RITS.scalapack ^openblas ^openmpi -tm
        - UCL-RITS.Eigen %{{compiler}}

    - vimrc:
        makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            noremap <F5> :Autoformat<CR>
            let g:formatdef_llvm_cpp = '"clang-format -style=file"'
            let g:formatters_cpp = ['llvm_cpp']
{% if python == "python3" %}
            let g:syntastic_python_python_exe = "python3"
{% endif %}

    - footer:
        setenv('ESPRESSO_PSEUDO', pathJoin(homedir, 'data', 'upf_files'))
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
      - traitlets
      - pip
      - six
      - traitlets
      - f90nml
    - bin_env: {{salt['funwith.prefix'](project)}}
    - upgrade: True
    - env_vars:
        CC: {{salt['spack.package_prefix']('openmpi %%%s' % compiler)}}/bin/mpicc
    - use_wheel: True
{% endfor %}
