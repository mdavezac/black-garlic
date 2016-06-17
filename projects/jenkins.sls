{% from 'projects/fixtures.sls' import tmuxinator %}
{% set project = "jenkins" %}
{% set prefix = salt['funwith.prefix'](project) %}
{% set home = grains['userhome'] %}

ucl-rits/jenkins-job-builder-files:
  github.present:
    - target: {{prefix}}/src/{{project}}

UCL/jenkjobs:
  github.present:
    - target: {{prefix}}/src/JenkJobs

UCL-RITS/rc_puppet:
  github.present:
    - target: {{prefix}}/src/rc-puppet

UCL-RITS/rcps-buildscripts:
  github.present:
    - target: {{prefix}}/src/buildscripts

{{prefix}}:
  virtualenv.managed:
    - python: python2
    - use_wheel: True
    - pip_upgrade: True
    - pip_pkgs:
      - pip
      - ipython[all]
      - numpy
      - scipy
      - pytest
      - pandas
      - cython
      - python-jenkins==0.4.8
      - jenkins-job-builder
      - git+https://github.com/UCL/jenkjobs


{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{prefix}}
    - makeprg: False
    - footer: au BufRead,BufNewFile *_install setfiletype sh


{{prefix}}/bin/production.sh:
  file.managed:
    - mode: 0775
    - contents: |
        #! /usr/local/bin/zsh
        echo "UCL RSDT Jenkins" > {{prefix}}/src/{{project}}/jenkinsdescription.yaml
        jenkins-jobs --ignore-cache --conf {{prefix}}/.production.ini "$@"


{{prefix}}/bin/staging.sh:
  file.managed:
    - mode: 0775
    - contents: |
        #! /usr/local/bin/zsh
        echo "UCL RSDT Jenkins (Staging)" > {{prefix}}/src/{{project}}/jenkinsdescription.yaml
        jenkins-jobs --ignore-cache --conf {{prefix}}/.staging.ini "$@"

{{prefix}}/src/{{project}}/purify-slack-token:
  file.managed:
    - mode: 0500
    - contents: {{salt['pillar.get']('slack_token:bico')}}

{{prefix}}/src/{{project}}/ucl-rits-slack-token:
  file.managed:
    - mode: 0500
    - contents: {{salt['pillar.get']('slack_token:rits')}}

{{project}}:
  funwith.modulefile:
    - prefix: {{prefix}}
    - cwd: {{prefix}}/src/{{project}}
    - virtualenv: {{project}}


{{prefix}}/.staging.ini:
  file.managed:
    - contents: |
        [jenkins]
        user=mdavezac
        password={{salt['pillar.get']('jenkins_token:staging')}}
        url=http://staging.development.rc.ucl.ac.uk/jenkins/

{{prefix}}/.production.ini:
  file.managed:
    - contents: |
        [jenkins]
        user=mdavezac
        password={{salt['pillar.get']('jenkins_token:production')}}
        url=http://development.rc.ucl.ac.uk/jenkins/

{{prefix}}/src/jenkins/branch.yaml:
  file.managed:
    - contents: production

{{prefix}}/bin/build.zsh:
  file.managed:
    - contents: ssh jenkins_legion "bash -l" < $1
    - mode: 700

{{tmuxinator(project, root="%s/src/%s" % (prefix, project))}}
