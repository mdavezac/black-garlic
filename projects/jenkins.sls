{% set prefix = salt['funwith.prefix']('jenkins') %}
jenkins:
  funwith.present:
    - github : ucl-rits/jenkins-job-builder-files
    - srcname: jenkins
    - virtualenv:
        system_site_packages: True
        python: python2
        use_wheel: True
        pip_upgrade: True
        pip_pkgs:
          - ipython[all]
          - numpy
          - scipy
          - pytest
          - pandas
          - cython
          - python-jenkins==0.4.8
          - jenkins-job-builder
          - git+https://github.com/UCL/jenkjobs
          - git+https://github.com/asmundg/jenkins-jobs-slack.git

    - vimrc:
        makeprg: False
        footer: au BufRead,BufNewFile *_install setfiletype sh

    - footer: |
        set_alias("production", "jenkins-jobs --ignore-cache --conf {{prefix}}/.production.ini")
        set_alias("staging", "jenkins-jobs --ignore-cache --conf {{prefix}}/.staging.ini")


UCL-RITS/rc_puppet:
  github.present:
    - target: {{prefix}}/src/rc-puppet

UCL-RITS/rcps-buildscripts:
  github.present:
    - target: {{prefix}}/src/buildscripts

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
        url=http://staging.development.rc.ucl.ac.uk/jenkins/

{{prefix}}/src/jenkins/branch.yaml:
  file.managed:
    - contents: production

{{prefix}}/bin/build.zsh:
  file.managed:
    - contents: ssh jenkins_legion "bash -l" < $1
    - mode: 700
