{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt['pillar.get']('compiler', 'gcc') %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = "pylada-light" %}
{% set workspace = salt['funwith.workspace'](project) %}

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - GreatCMakeCookoff
      - espresso %{{compiler}} +mpi +scalapack ^openblas ^openmpi -pmi
      - eigen %{{compiler}} -fftw -scotch -metis -suitesparse

{{workspace}}/{{python}}:
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
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - email: mdavezac@gmail.com

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: *spack_packages
    - virtualenv: {{workspace}}/{{python}}
    - footer:
        setenv('ESPRESSO_PSEUDO',
               pathJoin("{{salt['funwith.workspace']("data")}}", "espresso", 'upf_files'))
{% if compiler != 'intel' %}
        setenv('FC', 'gfortran')
{% else %}
        setenv('FC', 'ifort')
{% endif %}

{{project}} cppconfig:
  funwith.add_cppconfig:
    - prefix: {{workspace}}
    - cpp11: True
    - source_dir: {{workspace}}/src/{{project}}
    - source_includes:
        - ./

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}
    - exclude: ['.git', 'build']
    - ctags: True

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - footer: |
        let g:ycm_collect_identifiers_from_tags_files=1
        noremap <F5> :Autoformat<CR>
        let g:formatdef_llvm_cpp = '"clang-format -style=file"'
        let g:formatters_cpp = ['llvm_cpp']
        let g:syntastic_python_python_exe = "{{workspace}}/bin/python"
        let g:syntastic_python_checkers = ['pyflakes']
        let g:syntastic_enable_balloons = 1


{{salt['funwith.workspace']("data")}}:
  file.directory

{{salt['funwith.workspace']("data")}}/espresso:
  archive.extracted:
    - archive_format: tar
    - source_hash: md5=aefb62ca035b57eb4680ab851219b20b
    - source: http://www.quantum-espresso.org/wp-content/uploads/upf_files/upf_files.tar


{{salt['funwith.workspace']("data")}}/espresso/INPUT_PW.html:
  file.managed:
    - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PW.html
    - source_hash: md5=6afe69467c39dcc76156cfc5c6667039
    - makedirs: True

{{salt['funwith.workspace']("data")}}/espresso/INPUT_PH.html:
  file.managed:
    - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PH.html
    - source_hash: md5=a3d484716851b7478138a2c164915f0c

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), file="crystal/__init__.py")}}
