{% from "projects/fixtures.sls" import tmuxinator %}
{% set brewprefix = "/usr/local/opt/" %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt["spack.python"]() %}
{% set python_exec = salt["spack.python_exec"]() %}
{% set project = sls.split(".")[-1] %}
{% set workspace = salt["funwith.workspace"](project) %}

{{project}} packages:
  pkg.installed:
    - pkgs:
      - caskroom/cask/unity-hub
      - caskroom/cask/dotnet-sdk
      - mono
      - docker-credential-helper

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - fftw %{{compiler}} -mpi

{{workspace}}/src/:
  file.directory

kagenova/kage-core:
  gitlab.latest:
    - target: {{workspace}}/src/kage-core
    - update_head: False

# kagenova/kage-move:
#   gitlab.latest:
#     - target: {{workspace}}/src/kage-move
#     - update_head: False

# kagenova/kage-render:
#   github.latest:
#     - target: {{workspace}}/src/kage-render
#     - update_head: False


# {{workspace}}/{{python}}:
#   virtualenv.managed:
#     - python: {{python_exec}}
#     - pip_upgrade: True
#     - pip_pkgs: [pip, numpy, scipy, pytest, pandas, matplotlib, jupyter]


{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - spack: *spack_packages
    - workspace: {{workspace}}
    - virtualenv: {{workspace}}/{{python}}
    - cwd: {{workspace}}/src/kage-core


{{workspace}}/.cppconfig:
  file.managed:
    - contents: |
        -std=c++17
        -I{{workspace}}/src/kage-core
        -isystem{{workspace}}/src/kage-core/build/external/include
        -I{{workspace}}/src/kage-core/build/include

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - makeprg: "cmake\\ --build\\ $CURRENT_FUN_WITH_DIR/build/"
    - width: 80
    - tabs: 2
    - footer: |
            let g:LanguageClient_serverCommands = {
            \ 'cpp': ['{{brewprefix}}/cquery/bin/cquery', '--log-file=/tmp/cq.log',
            \         '--init={"cacheDirectory":"{{workspace}}/var/cquery//src/{{project}}/.vscode/cquery_cached_index"}']                                                                                                                                                                              
            \ }

{{tmuxinator(project, root="%s/src/kage-core" % workspace, layout="main-horizontal")}}
