{% if grains['os'] == "MacOS" %}
iterm:
  schemes:
    - Solarized Darcula
    - Solarized Dark - Patched
    - Solarized Dark Higher Contrast
    - Solarized Dark
    - Solarized Light
    - Atom
    - AtomOneLight
    - Hybrid
    - Gruvbox Dark
    - Slate
shell: /usr/local/bin/zsh
{% else %}
shell: /usr/bin/zsh
{% endif %}
