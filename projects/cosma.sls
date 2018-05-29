{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt['spack.python']() %}
{% set python_exec = salt['spack.python_exec']() %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - GreatCMakeCookoff
      - mpich %{{compiler}}
      - fftw %{{compiler}} +mpi ^mpich
      - openblas %{{compiler}}

google-cloud-sdk:
  cask.installed

{% set salted = salt['pillar.get']('zsh:salted', grains['userhome'] + "/.salted") %}
append gcloud completion:
  file.append:
    - name: {{salted}}/settings.zsh
    - text: |
          # add gcloud completion
          caskroom_dir="/usr/local/Caskroom"
          gcloud_dir="$caskroom_dir/google-cloud-sdk/latest/google-cloud-sdk"
          source $gcloud_dir/completion.zsh.inc


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - cwd: {{workspace}}/src/{{project}}
    - spack: *spack_packages
    - virtualenv: {{workspace}}/{{python}}
    - footer:
        setenv('FC', 'gfortran')
        setenv("JULIA_PKGDIR", "{{workspace}}/julia")

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
      - pandas
      - matplotlib
      - jupyter
      - ipython[all]
      - ipdb
    - env_vars:
        VIRTUAL_ENV: {{workspace}}/{{python}}


mdavezac/CloudProject:
  github.latest:
    - target: {{workspace}}/src/{{project}}
    - email: m.davezac@imperial.ac.uk

Azure/batch-shipyard:
  github.latest:
    - target: {{workspace}}/src/shipyard
    - email: m.davezac@imperial.ac.uk

{{workspace}}/julia/v0.6/REQUIRE:
  file.managed:
    - contents: |
        FillArrays
        OhMyREPL
        Revise
        DataFrame
        Plots
        StatPlots
        Glob
        Query
        RDatasets
        PyPlot
        PlotlyJS
        GR
        UnicodePlots
    - makedirs: True

julia metadir:
    github.latest:
      - name: JuliaLang/METADATA.jl
      - email: m.davezac@imperial.ac.uk
      - target: {{workspace}}/julia/v0.6/METADATA
      - force_fetch: True

update julia packages:
  cmd.run:
    - name: julia -e "Pkg.resolve()"
    - env:
      - JULIA_PKGDIR: {{workspace}}/julia
      - JUPYTER: {{workspace}}/bin/jupyter

{{tmuxinator(project, root="%s/src/%s" % (workspace, project))}}
