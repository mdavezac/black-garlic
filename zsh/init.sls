zsh:
  pkg.installed:
    - pkgs:
      - zsh
      - zsh-lovers
      - zplug

include:
  - .powerfonts
  - .prezto
  - .iterm2
  - .completions
  - .dotfiles
  - .settings

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
