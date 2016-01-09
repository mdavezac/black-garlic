{% set user = grains['user'] %}
{% set home = "/Users/" + user %}
{% set dotfiles = home + "/.dotfiles" %}

include:
  - zsh
  - dotfiles.vim

dotfiles:
  github:
    - latest
    - name: {{user}}/dotfiles
    - target: {{dotfiles}}
    - email: mdavezac@gmail.com

run set of files in .zshrc:
  file.append:
    - name: {{home}}/.zshrc
    - text: |
        for filename in {{dotfiles}}/zsh/*.zsh; do
          source $filename
        done

add line to {{home}}/.zpreztorc:
  file.append:
    - name: {{home}}/.zpreztorc
    - text: source {{dotfiles}}/zsh/preztorc

add line to {{home}}/.zprofile:
  file.append:
    - name: {{home}}/.zprofile
    - text: source {{dotfiles}}/zsh/zprofile

{{home}}/.zprezto/modules/prompt/functions/prompt_funwith_setup:
  file.symlink:
    - target: {{dotfiles}}/zsh/prompts/funwith.zsh

add shell to acceptable shells:
  cmd.run:
    - unless: grep "{{pillar['shell']}}" /etc/shells
    - name: |
        sudo chmod o+w /etc/shells
        echo "{{pillar['shell']}}" >> /etc/shells
        sudo chmod o-w /etc/shells

change my shell:
  cmd.run:
    - unless: test $SHELL -ef {{pillar['shell']}} && test -e {{pillar['shell']}}
    - name: chsh -s {{pillar['shell']}} {{grains['user']}}
