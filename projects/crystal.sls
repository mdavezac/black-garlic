{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt['pillar.get']('compiler', 'gcc') %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

{{workspace}}/julia/v0.5/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        FactCheck
        FixedSizeArrays
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


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/julia/v0.5/Crystals
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 80
    - tabs: 4

{{tmuxinator(project, root="%s/julia/v0.5/Crystals" % workspace, layout="main-horizontal")}}
