{% for key, value in pillar.get('git_global', {}).items() %}
user config {{key}}:
  git.config_set:
    - name: {{key}}
    - value: {{value}}
    - global: True
{% endfor      %}

{% for key, value in pillar.get('secrets.git', {}).items() %}
user config {{key}}:
  git.config_set:
    - name: {{key}}
    - value: {{value}}
    - global: True
{% endfor      %}

{{grains['userhome']}}/.gitignore:
  file.managed:
    - source: salt://files/gitignore
    - mode: 600
    - user: {{grains['user']}}
