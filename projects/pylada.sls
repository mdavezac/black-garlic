{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt['spack.python']() %}
{% set python_exec = salt['spack.python_exec']() %}
{% set project = "pylada-light" %}
{% set workspace = salt['funwith.workspace'](project) %}

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - openmpi %gcc
      - openblas %gcc
      - netlib-scalapack %gcc ^openmpi ^openblas
      - quantum-espresso %gcc +mpi -elpa +scalapack ^netlib-scalapack ^openmpi ^openblas

{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - pip_pkgs:
      - pip
      - numpy
      - scipy
      - pytest
      - pandas
      - cython
      - quantities
      - nose
      - nose_parameterized
      - six
      - traitlets
      - f90nml
      - pyflakes
      - pytest-flakes
      - pytest-bdd
      - jupyter
      - jedi
      - neovim

mpi4py:
  pip.installed:
    - bin_env: {{workspace}}/{{python}}
    - pip_upgrade: True
    - env_vars:
        CC: {{salt['spack.package_prefix']('openmpi %gcc')}}/bin/mpicc

pylada/{{project}}:
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - unless: test -d {{workspace}}/src/{{project}}/.git

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - cwd: {{workspace}}/src/{{project}}
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

{{salt['funwith.workspace']("data")}}:
  file.directory

# {{salt['funwith.workspace']("data")}}/espresso:
#   archive.extracted:
#     - archive_format: tar
#     - source_hash: md5=aefb62ca035b57eb4680ab851219b20b
#     - source: http://www.quantum-espresso.org/wp-content/uploads/upf_files/upf_files.tar
# 
# 
# {{salt['funwith.workspace']("data")}}/espresso/INPUT_PW.html:
#   file.managed:
#     - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PW.html
#     - source_hash: md5=6afe69467c39dcc76156cfc5c6667039
#     - makedirs: True
# 
# {{salt['funwith.workspace']("data")}}/espresso/INPUT_PH.html:
#   file.managed:
#     - source: http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PH.html
#     - source_hash: md5=a3d484716851b7478138a2c164915f0c

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), file="crystal/__init__.py")}}
