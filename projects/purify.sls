{% from 'projects/fixtures.sls' import tmuxinator, jedi %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

include:
  - chilly-oil.projects.purify

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}
    - exclude: [".git", "build"]

{{project}} vimrc:
    funwith.add_vimrc:
      - name: {{workspace}}
      - source_dir: {{workspace}}/src/{{project}}
      - makeprg: True

{{workspace}}/.cppconfig:
  file.managed:
    - contents: |
          -isystem{{workspace}}/src/{{project}}/build/external/include
          -isystem{{workspace}}/src/{{project}}/build/external/include/eigen3
          -I{{workspace}}/src/{{project}}/build/include
          -I{{workspace}}/src/{{project}}/cpp
          -I{{workspace}}/src/{{project}}/cpp/examples
          -std=c++11
          -Wall
          -Wno-c++98-compat
          -Wno-c++98-compat-pedantic
          -Wno-documentation
          -Wno-documentation-unknown-command
          -Wno-source-uses-openmp
          -Wno-float-conversion
          -Wno-unkown-pragmas

{{tmuxinator('purify', root="%s/src/purify" % workspace)}}
{{jedi(workspace + "/" + python)}}
