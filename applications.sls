applications:
  pkg.installed:
    - pkgs:
      - pandoc
{% if grains['os'] == 'Ubuntu' %}
      - slack
      - context
      - chromium-browser
      - lastpass-cli
{% elif grains['os'] == 'MacOS' %}
      - cscope
{% endif %}

{% if grains['os'] == 'MacOS' %}
cask applications:
  cask.installed:
    - pkgs:
      - slack
      - iterm2
      - google-chrome
      - dropbox
{% endif  %}
