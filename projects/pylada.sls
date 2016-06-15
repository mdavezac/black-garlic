{% from 'projects/fixtures.sls' import tmuxinator %}
{% set prefix = salt['funwith.prefix']('pylada-light') %}
{% set compiler = "gcc" %}
{% set python = "python3" %}
{% set project = "pylada-light" %}
{% set spack_packages = [
    "GreatCMakeCookoff",
    "espresso +mpi +scalapack ^openblas ^openmpi -pmi",
    "eigen -fftw -scotch -metis -suitesparse"
]%}

{{project}} spack packages:
  spack.installed:
    - compiler: {{compiler}}
    - pkgs: {{spack_packages}}

{{prefix}}:
  virtualenv.managed:
    - python: {{python}}
    - pip_upgrade: True
    - env_vars:
        CC: {{salt['spack.package_prefix']('openmpi %%%s' % compiler)}}/bin/mpicc
    - use_wheel: True
    - pip_pkgs:
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

pylada/{{project}}:
  github.present:
    - target: {{prefix}}/src/{{project}}

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: {{spack_packages}}
    - compiler: {{compiler}}
    - footer:
        setenv('ESPRESSO_PSEUDO',
               pathJoin("{{salt['funwith.prefix']("data")}}", "espresso", 'upf_files'))
{% if compiler != 'intel' %}
        setenv('FC', 'gfortran')
{% else %}
        setenv('FC', 'ifort')
{% endif %}

{{project}} cppconfig:
  funwith.add_cppconfig:
    - prefix: {{prefix}}
    - cpp11: True
    - source_dir: {{prefix}}/src/{{project}}
    - source_includes:
        - ./

{{project}} ctags:
  ctags.run:
    - name: {{prefix}}/src/{{project}}
    - exclude: ['.git', 'build']
    - ctags: True

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{prefix}}
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


{{salt['funwith.prefix']("data")}}:
  file.directory

{{salt['funwith.prefix']("data")}}/espresso:
  archive.extracted:
    - archive_format: tar
    - source_hash: md5=aefb62ca035b57eb4680ab851219b20b
    - source: http://www.quantum-espresso.org/wp-content/uploads/upf_files/upf_files.tar


{{salt['funwith.prefix']("data")}}/espresso/INPUT_PW.html:
  file.managed:
    - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PW.html
    - source_hash: md5=6afe69467c39dcc76156cfc5c6667039
    - makedirs: True

{{salt['funwith.prefix']("data")}}/espresso/INPUT_PH.html:
  file.managed:
    - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PH.html
    - source_hash: md5=a3d484716851b7478138a2c164915f0c

{{tmuxinator(project, root="%s/src/%s" % (prefix, project), file="crystal/__init__.py")}}
