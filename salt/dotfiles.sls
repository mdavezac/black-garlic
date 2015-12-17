{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set dotfiles = home + "/.dotfiles" %}

include:
  - zsh
  - prezto
  - powerfonts

dotfiles:
  git.latest:
    - name: git@github.com:{{user}}/dotfiles
    - target: {{dotfiles}}
    - identity: {{home}}/.ssh/github_rsa
    - require:
      - pkg: applications
      - ssh_known_hosts: github.com

dotfiles email param:
  git.config_set:
    - repo: {{dotfiles}}
    - name: user.email
    - value: mdavezac@gmail.com
    - require:
      - git: dotfiles

github.com:
  ssh_known_hosts:
    - present
    - user: mdavezac
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48

run set of files in .zshrc:
  file.append:
    - name: {{home}}/.zshrc
    - text: |
        for filename in {{dotfiles}}/zsh/*.zsh; do
          source $filename
        done
    - require:
      - git: dotfiles

{{home}}/.zpreztorc:
  file.symlink:
    - target: {{dotfiles}}/zsh/zpreztorc
    - require:
      - git: dotfiles

{{home}}/.zprofile:
  file.symlink:
    - target: {{dotfiles}}/zsh/zprofile
    - require:
      - git: dotfiles
