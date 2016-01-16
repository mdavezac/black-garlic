git:
  pkg.installed


{% for key, value in pillar.get('git_global', {}).items() %}
user config {{key}}:
  git.config_set:
    - name: {{key}}
    - value: {{value}}
    - global: True
{% endfor      %}
