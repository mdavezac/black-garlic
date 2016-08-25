{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt['pillar.get']('compiler', 'gcc') %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

{{workspace}}/julia/v0.4/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        FactCheck
        FixedSizeArrays
    - makedirs: True

julia metadir:
    git.latest:
      - name: git://github.com/JuliaLang/METADATA.jl
      - target: {{workspace}}/julia/v0.4/METADATA
      - force_fetch: True


update julia packages:
  cmd.run:
    - name: julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/bin/jupyter


mdavezac/Crystals.jl:
  github.latest:
    - target: {{workspace}}/julia/v0.4/Crystals
    - update_head: False


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/julia/v0.4/Crystals
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"

{{tmuxinator(project, root="%s/julia/v0.4/Crystals" % workspace, layout="main-horizontal")}}
