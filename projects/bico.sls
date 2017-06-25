{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt['pillar.get']('compiler', 'gcc') %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.bico

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/sopt

{{workspace}}/.cppconfig:
  file.managed:
    - contents: |
        -isystem {{workspace}}/src/{{project}}build/external/include
        -I{{workspace}}/src/{{project}}/build/include
        -I{{workspace}}/src/{{project}}/cpp
{% if python == 'python3' %}
        -isystem{{workspace}}/include/python3.5m
{% else %}
        -isystem{{workspace}}/include/python2.7
{% endif %}
        -std=c++11
        -Wall
        -Wno-c++98-compat
        -Wno-c++98-compat-pedantic
        -Wno-documentation
        -Wno-documentation-unknown-command
        -Wno-source-uses-openmp
        -Wno-float-conversion

{{workspace}}/julia/v0.5/REQUIRE:
  file.managed:
    - contents: |
        DataFrames
        FactCheck
        FixedSizeArrays
        Cxx
        IJulia
    - makedirs: True

julia metadir:
  github.latest:
    - name: JuliaLang/METADATA.jl
    - target: {{workspace}}/julia/v0.5/METADATA
    - force_fetch: True

update julia packages:
  cmd.run:
    - name: julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/bin/jupyter

add to modulefile:
  file.append:
    - name: {{salt['funwith.defaults']('modulefiles')}}/{{project}}.lua
    - text: setenv("JULIA_PKGDIR", "{{workspace}}/julia")

{{tmuxinator(project, root="%s/src/sopt" % workspace)}}
