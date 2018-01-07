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
    - mode: 400
    - user: {{grains['user']}}
