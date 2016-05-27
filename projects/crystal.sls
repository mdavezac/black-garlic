{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = "crystal" %}
{% set prefix = salt['funwith.prefix'](project) %}
{% set home = grains['userhome'] %}
{% set compiler = "clang" %}

{{prefix}}:
  file.directory:
    - makedirs: True

julia metadir:
    git.latest:
      - name: git://github.com/JuliaLang/METADATA.jl
      - target: {{prefix}}/julia/v0.4/METADATA
      - update_head: True
      - force_fetch: True


{{prefix}}/julia/v0.4/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        FactCheck

update julia packages:
  cmd.run:
    - name: julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{prefix}}/julia
      - JUPYTER: {{prefix}}/bin/jupyter

mdavezac/Crystal.jl:
  github.present:
    - target: {{prefix}}/julia/v0.4/Crystal


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - prefix: {{prefix}}
    - cwd: {{prefix}}/julia/v0.4/Crystal
    - footer: |
        setenv("JULIA_PKGDIR", "{{prefix}}/julia")
        prepend_path("DYLD_LIBRARY_PATH", "/usr/lib")

{{tmuxinator(project, root="%s/julia/v0.4/Crystal" % prefix)}}
