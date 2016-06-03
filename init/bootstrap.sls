# This sets permissions for running brew at /usr/local
# It takes while to execute, so it is better to leave it out unless necessary
CondimentStation:
  group.present: []
  user.present:
    - name: {{pillar['user']}}
    - optional_groups:
      - CondimentStation

  file.directory:
    - name: /usr/local
    - recurse:
      - group
      - mode
    - dir_mode: 774
    - group: CondimentStation
    - user: {{pillar['user']}}
