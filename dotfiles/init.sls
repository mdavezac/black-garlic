{% set user = grains['user'] %}
{% set home = grains['userhome'] %}
{% set dotdir = pillar.get('dotdir', grains['userhome'] + "/.dotfiles") %}

include:
  - zsh
  - .vim

dotfiles:
  github:
    - latest
    - name: {{user}}/dotfiles
    - target: {{dotdir}}
    - email: mdavezac@gmail.com

run set of files in .zshrc:
  file.append:
    - name: {{home}}/.zshrc
    - text: |
        for filename in {{dotdir}}/zsh/*.zsh; do
          source $filename
        done

add line to {{home}}/.zpreztorc:
  file.append:
    - name: {{home}}/.zpreztorc
    - text: source {{dotdir}}/zsh/preztorc

add line to {{home}}/.zprofile:
  file.append:
    - name: {{home}}/.zprofile
    - text: source {{dotdir}}/zsh/zprofile

{{home}}/.zprezto/modules/prompt/functions/prompt_funwith_setup:
  file.symlink:
    - target: {{dotdir}}/zsh/prompts/funwith.zsh

{{home}}/.ctags:
  file.symlink:
    - target: {{dotdir}}/ctags

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
