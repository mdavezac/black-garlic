{% set packages = ['vim-mode-plus', 'solarized-dark-ui', 'uber-juno'] %}
atom:
  cask.installed

{% set packages = ['vim-mode-plus', 'uber-juno'] %}
=======
{% for package in packages %}
atom {{package}}:
  cmd.run:
    - name: apm install {{package}}
    - creates: {{grains['userhome']}}/.atom/packages/{{package}}
{% endfor %}

