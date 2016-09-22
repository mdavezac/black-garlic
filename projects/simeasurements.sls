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
    git.latest:
      - name: git://github.com/JuliaLang/METADATA.jl
      - target: {{workspace}}/julia/v0.5/METADATA
      - force_fetch: True


update julia packages:
  cmd.run:
    - name: /Applications/Julia-0.5.app/Contents/Resources/julia/bin/julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/bin/jupyter


mdavezac/SIMeasurements.jl:
  github.latest:
    - target: {{workspace}}/julia/v0.5/SIMeasurements
    - update_head: False

config mdavezac/SIMeasurements.jl:
  git.config_set:
    - name: user.email
    - value: mdavezac@gmail.com
    - repo: {{workspace}}/julia/v0.5/SIMeasurements

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}
    - cwd: {{workspace}}/julia/v0.5/SIMeasurements
    - footer: |
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")
        prepend_path("PATH", "/Applications/Julia-0.5.app/Contents/Resources/julia/bin")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "make\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 80
    - tabs: 4

{{tmuxinator(project, root="%s/julia/v0.5/SIMeasurements" % workspace, layout="main-horizontal")}}
