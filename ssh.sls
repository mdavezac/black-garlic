{{grains['userhome']}}/.ssh:
  file.directory:
    - user: {{grains['user']}}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - mode

{{grains['userhome']}}/.ssh/config:
  file.managed:
    - source: salt://files/sshconfig
    - template: jinja
    - context:
        legion:
            legion: legion.rc.ucl.ac.uk
            legion_login05: login05.external.legion.ucl.ac.uk
            legion_login06: login06.external.legion.ucl.ac.uk
            legion_login07: login07.external.legion.ucl.ac.uk
            legion_login08: login08.external.legion.ucl.ac.uk
            legion_login09: login09.external.legion.ucl.ac.uk
    - mode: 400
    - user: {{grains['user']}}
