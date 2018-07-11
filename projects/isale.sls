{% from "projects/fixtures.sls" import tmuxinator %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}
{% set compiler = salt["spack.compiler"]() %}
{% set mpilib = salt["pillar.get"]("mpi", "openmpi")  %}
{% set brewprefix = "/usr/local/opt/" %}

bear:
  pkg.installed

spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - vtk %{{compiler}} build_type="Debug" ^ hdf5~mpi ^netcdf ~mpi
      - {{mpilib}} %{{compiler}}


ImperialCollegeLondon/isale-dev:
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - update_head: False

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: *spack_packages
    - virtualenv: {{workspace}}/{{python}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/src/{{project}}

{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - system_site_packages: False

python_packages:
  pip.installed:
    - bin_env: {{workspace}}/{{python}}/bin/pip
    - upgrade: True
    - pkgs: 
      - pip
      - numpy
      - scipy
      - pytest
      - pytest-runner
      - pandas
      - matplotlib
      - jupyter
      - ipython
      - ipdb
    - env_vars:
        VIRTUAL_ENV: {{workspace}}/{{python}}

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - source_dir: {{workspace}}/src/{{project}}
    - tabs: 2
    - footer: |
       let g:neomake_python_enabled_makers = ["flake8"]
       let g:github_upstream_issues = 1
       let g:gutentags_ctags_exclude = [".tox", "build"]
       let g:github_issues_max_pages=7
       let g:github_upstream_issues=1

{{project}} cppconfig:
  file.managed:
    - name: {{workspace}}/.cppconfig
    - content: |
        -std=c++11
        -Wall
        -I{{workspace}}/src/{{project}}/build
        -I{{brewprefix}}/vtk/include/vtk-8.1

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
