{% from "projects/fixtures.sls" import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set mpilib = salt["pillar.get"]("mpi", "openmpi")  %}
{% set openmp = "-openmp" if compiler != "clang" else "-openmp"%}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - hdf5 -fortran -cxx -mpi %{{compiler}}
      - {{mpilib}} %{{compiler}}
      # - libxc
{% if compiler == "intel" %}
      - openblas {{openmp}} %intel
      - scalapack +debug %intel  ^{{mpilib}} ^openblas {{openmp}}
{% else %}
      - openblas %{{compiler}} {{openmp}}
      - scalapack +debug %{{compiler}}  ^{{mpilib}} ^openblas {{openmp}}
{% endif %}

{{workspace}}/julia/v0.5/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        FactCheck
        Lumberjack
        Unitful
        AffineTransforms
        Documenter
        DocStringExtensions
    - makedirs: True

julia metadir:
    github.latest:
      - name: JuliaLang/METADATA.jl
      - email: mdavezac@gmail.com
      - target: {{workspace}}/julia/v0.5/METADATA
      - force_fetch: True


update julia packages:
  cmd.run:
    - name: julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/bin/jupyter


mdavezac/Crystals.jl:
  github.latest:
    - target: {{workspace}}/julia/v0.5/Crystals
    - email: mdavezac@gmail.com
    - update_head: False


{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - use_wheel: True
    - pip_pkgs: [pip, numpy, scipy, pytest, pandas, cython, pyWavelets, jupyter]


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: *spack_packages
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/julia/v0.5/Crystals
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 92
    - tabs: 4

{{project}} gpaw:
  gitlab.latest:
    - name: gpaw/gpaw.git
    - email: mdavezac@gmail.com
    - target: {{workspace}}/src/gpaw
    - force_fetch: True

{{tmuxinator(project, root="%s/julia/v0.5/Crystals" % workspace, layout="main-horizontal")}}
