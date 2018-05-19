{% from "projects/fixtures.sls" import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

unity:
  cask.installed

dotnet-sdk:
  cask.installed

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - fftw %{{compiler}} -mpi

{{workspace}}/julia/v0.6/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        Unitful
        Documenter
        DocStringExtensions
        AxisArrays
        Revise
        OhMyREPL
        ArgCheck
        Lint
        PkgDev
        IterTools
    - makedirs: True

julia metadir:
    github.latest:
      - name: JuliaLang/METADATA.jl
      - email: mdavezac@gmail.com
      - target: {{workspace}}/julia/v0.6/METADATA
      - force_fetch: True


{{workspace}}/src/:
  file.directory

kagenova/kage-core:
  gitlab.latest:
    - target: {{workspace}}/src/kage-core
    - email: mdavezac@gmail.com
    - update_head: False

# kagenova/kage-render:
#   github.latest:
#     - target: {{workspace}}/src/kage-render
#     - email: mdavezac@gmail.com
#     - update_head: False


{{workspace}}/{{python}}:
  virtualenv.managed:
    - python: {{python_exec}}
    - pip_upgrade: True
    - use_wheel: True
    - pip_pkgs: [pip, numpy, scipy, pytest, pandas, matplotlib, jupyter]

update julia packages:
  cmd.run:
    - name: julia --startup-file=no -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/{{python}}/bin/jupyter


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: *spack_packages
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/src/kage-core
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")


{{workspace}}/.cppconfig:
  file.managed:
    - contents: |
        -std=c++14
        -I{{workspace}}/src/kage-core
        -isystem{{workspace}}/src/kage-core/build/external/include
        -I{{workspace}}/src/kage-core/build/include

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "cmake\\ --build\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 100
    - tabs: 2

{{tmuxinator(project, root="%s/src/kage-core" % workspace, layout="main-horizontal")}}
