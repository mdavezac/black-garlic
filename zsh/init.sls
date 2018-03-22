zsh:
  pkg.installed:
    - pkgs:
      - zsh
      - zsh-lovers
{% if grains['os'] == "MacOS" %}
      - zplug
{% endif %}

include:
  - .powerfonts
  - .prezto
  - .completions
  - .dotfiles
  - .settings
{% if grains['os'] == "MacOS" %}
  - .iterm2
{% endif %}

add shell to acceptable shells:
  cmd.run:
    - unless: grep "{{pillar['shell']}}" /etc/shells
    - name: |
        sudo chmod o+w /etc/shells
        echo "{{pillar['shell']}}" >> /etc/shells
        sudo chmod o-w /etc/shells
