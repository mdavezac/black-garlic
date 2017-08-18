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
      - netlib-scalapack %intel  ^{{mpilib}} ^openblas {{openmp}}
{% else %}
      - openblas %{{compiler}} {{openmp}}
      - netlib-scalapack %{{compiler}}  ^{{mpilib}} ^openblas {{openmp}}
{% endif %}

{{workspace}}/julia/v0.6/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        FactCheck
        Lumberjack
        Unitful
        AffineTransforms
        Documenter
        DocStringExtensions
        AxisArrays
    - makedirs: True

julia metadir:
    github.latest:
      - name: JuliaLang/METADATA.jl
      - email: mdavezac@gmail.com
      - target: {{workspace}}/julia/v0.6/METADATA
      - force_fetch: True



mdavezac/Crystals.jl:
  github.latest:
    - target: {{workspace}}/julia/v0.6/Crystals
    - email: mdavezac@gmail.com
    - update_head: False

mdavezac/UnitfulHartree.jl:
  github.latest:
    - target: {{workspace}}/julia/v0.6/UnitfulHartree
    - email: mdavezac@gmail.com
    - update_head: False

mdavezac/LibXC.jl:
  github.latest:
      - target: {{workspace}}/julia/v0.6/LibXC
      - email: mdavezac@gmail.com

mdavezac/AtomicDFT.jl:
  github.latest:
    - target: {{workspace}}/julia/v0.6/AtomicDFT
    - email: mdavezac@gmail.com

update julia packages:
  cmd.run:
    - name: julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/bin/jupyter


{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - use_wheel: True
    - pip_pkgs: [pip, numpy, scipy, pytest, pandas, cython, matplotlib, jupyter, ase, neovim]


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: *spack_packages
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/julia/v0.6/LibXC
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
    - name: gpaw/gpaw
    - email: mdavezac@gmail.com
    - target: {{workspace}}/src/gpaw
    - force_fetch: True

{{tmuxinator(project, root="%s/julia/v0.6/LibXC" % workspace, layout="main-horizontal")}}
