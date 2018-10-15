{% from "projects/fixtures.sls" import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

# {{workspace}}/julia/v0.6/REQUIRE:
#   file.managed:
#     - contents: |
#         FillArrays
#         OhMyREPL
#         Revise
#     - makedirs: True


# julia metadir:
#     github.latest:
#       - name: JuliaLang/METADATA.jl
#       - email: m.davezac@imperial.ac.uk
#       - target: {{workspace}}/julia/v0.6/METADATA
#       - force_fetch: True
# 
ImperialCollegeLondon/BlockBandedMatrices.jl:
  github.latest:
    - target: {{workspace}}/src/BlockBandedMatrices
    - email: 2745737+mdavezac@users.noreply.github.com
    - update_head: False

ImperialCollegeLondon/BandedMatrices.jl:
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - email: 2745737+mdavezac@users.noreply.github.com
    - update_head: False
# 
# {{workspace}}/julia/v0.6/BandedMatrices:
#     file.symlink:
#       - target: {{workspace}}/src/{{project}}
# 
# update julia packages:
#   cmd.run:
#     - name: julia -e "Pkg.resolve()"
#     - env:
#       - JULIA_PKGDIR: {{workspace}}/julia
#       - JUPYTER: {{workspace}}/bin/jupyter

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/src/{{project}}
    - footer: |
        setenv("JULIA_PROJTECT", "{{workspace}}/src/BlockBandedMatrices")

{{tmuxinator(project, root="%s/src/%s" % (workspace, project), layout="main-horizontal")}}
