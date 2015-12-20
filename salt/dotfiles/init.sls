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
    - require:
      - github: dotfiles

{{home}}/.zpreztorc:
  file.symlink:
    - target: {{dotfiles}}/zsh/zpreztorc
    - require:
      - github: dotfiles

{{home}}/.zprofile:
  file.symlink:
    - target: {{dotfiles}}/zsh/zprofile
    - require:
      - github: dotfiles

{{home}}/.zprezto/modules/prompt/functions/prompt_funwith_setup:
  file.symlink:
    - target: {{dotfiles}}/zsh/prompts/funwith.zsh
    - require:
      - github: dotfiles

