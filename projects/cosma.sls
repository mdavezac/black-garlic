{% from 'projects/fixtures.sls' import tmuxinator %}
{% set compiler = salt["spack.compiler"]() %}
{% set python = salt['spack.python']() %}
{% set python_exec = salt['spack.python_exec']() %}
{% set project = "pylada-light" %}
{% set workspace = salt['funwith.workspace'](project) %}

{{project}} spack packages:
  spack.installed:
    - pkgs: &spack_packages
      - GreatCMakeCookoff
      - mpich %{{compiler}}
      - fftw %{{compiler}} +mpi ^mpich
      - openblas %{{compiler}}

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - cwd: {{workspace}}/src/{{project}}
    - spack: *spack_packages
    - virtualenv: {{workspace}}/{{python}}
    - footer:
        setenv('FC', 'gfortran')


{{tmuxinator(project, root="%s/src" % workspace)}}
