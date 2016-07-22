github.com:
  ssh_known_hosts:
    - present
    - user: mdavezac
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - order: 0

~/.ssh:
  file.directory:
    - order: 0
    - user: {{grains['user']}}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
        - user
        - mode

~/.ssh/github_rsa:
  file.exists:
    - user: {{grains['user']}}
    - mode: 600
