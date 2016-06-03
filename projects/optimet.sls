{% set project = "optimet" %}
{% set prefix = salt['funwith.prefix'](project) %}
{% set home = grains['userhome'] %}
{% set compiler = "gcc" %}
{% set openmp = "+openmp" if compiler != 'clang' else "-openmp"%}
{% set ldflags = "/usr/local/Cellar/gcc/5.3.0/lib/gcc/5/libgfortran.dylib" %}
{% set spack_packages = [ "f2c", "gsl", "boost", "hdf5 -fortran -cxx -mpi",
      "Catch", "UCL-RITS.eigen +debug", "openmpi -pmi", "gbenchmark",
      "openblas %s" % openmp,
      "scalapack +debug ^openblas %s ^openmpi -pmi" % openmp,
      "belos +mpi -openmp +lapack ^openblas %s ^openmpi -pmi" % openmp,
]%}

{% if compiler == "clang" %}
belos spack packages:
  spack.installed:
    - name: {{spack_packages[-1]}}
    - compiler: {{compiler}}
    - environ:
        LDFLAGS: {{ldflags}}
{% endif %}

{{project}} spack packages:
  spack.installed:
    - compiler: {{compiler}}
    - pkgs: {{spack_packages}}

{{prefix}}:
  virtualenv.managed:
    - python: python3
    - pip_upgrade: True
    - pip_pkgs:
      - pip
      - pandas
      - scipy
      - numpy
      - jupyter
      - ipywidgets
      - invoke
      - paramiko
      - py

{{project | upper}}/{{project | upper}}:
  github.present:
    - target: {{prefix}}/src/{{project}}
  # recursive clone does not work so well on salt
  cmd.run:
    - name: git submodule update --init --recursive
    - cwd: {{prefix}}/src/optimet
    - creates: {{prefix}}/src/optimet/test-data/.git


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - prefix: {{prefix}}
    - cwd: {{prefix}}/src/{{project}}
    - spack: {{spack_packages}}
    - compiler: {{compiler}}
    - footer: |
        setenv("BLA_VENDOR", "OpenBlas")
{% if compiler == "clang" %}
        setenv("LDFLAGS", "{{ldflags}}")
{% elif compiler == "gcc" %}
        setenv("LDFLAGS", "-lgfortran")
        setenv("CXXFLAGS", "-Wno-parentheses -Wno-deprecated-declarations")
        setenv("CXX", "g++-5")
        setenv("CC", "gcc-5")
{% endif %}
        setenv("JULIA_PKGDIR", "{{prefix}}/julia")

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{prefix}}
    - makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
    - footer: |
          let g:ycm_collect_identifiers_from_tags_files=1
          noremap <F5> :Autoformat<CR>
          let g:formatdef_llvm_cpp = '"clang-format -style=file"'
          let g:formatters_cpp = ['llvm_cpp']

{{project}} ctags:
  ctags.run:
    - name: {{prefix}}/src/{{project}}
    - exclude: ['.git', 'build']

{{project}} cppconfig:
  funwith.add_cppconfig:
    - prefix: {{prefix}}
    - cpp11: True
    - source_dir: {{prefix}}/src/{{project}}
    - source_includes:
        - build/include/optimet
        - ./

{{home}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{prefix}}/src/{{project}}
        pre_window: module load {{project}} && setopt share_history
        windows:
          - {{project}}:
              layout: main-horizontal
              panes:
                - vim:
                  - vim Solver.cpp
                - build:
                  -
          - benchmarks:
              layout: main-horizontal
              panes:
                - build:
                  - ssh batman
                  - module load {{project}}/gnu
                  - cd work/benchmarking


{{project | upper}}/BenchmarkingData:
  github.present:
    - target: {{prefix}}/src/benchmark_data

{{prefix}}/julia:
  file.directory

julia package metadir:
  cmd.run:
    - creates: {{prefix}}/julia/v0.4/METADATA
    - name: julia -e "Pkg.init()"
    - env:
      - JULIA_PKGDIR: {{prefix}}/julia

git://github.com/JuliaLang/METADATA.jl:
  git.latest:
    - target: {{prefix}}/julia/v0.4/METADATA
    - update_head: True
    - force_fetch: True

julia:
  cask.installed

{% for pkg in ['YAML', 'DataFrames', 'Bokeh', 'Gadfly', 'IJulia']: %}
julia package {{pkg}}:
  cmd.run:
    - creates: {{prefix}}/julia/v0.4/{{pkg}}
    - name: julia -e "Pkg.add(\"{{pkg}}\")"
    - env:
      - JULIA_PKGDIR: {{prefix}}/julia
      - JUPYTER: {{prefix}}/bin/jupyter
{% endfor %}
