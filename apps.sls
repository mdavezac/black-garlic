{% set caskapps = salt['pillar.get']("cask_apps", []) %}

{% for app in caskapps %}
cask {{app}}:
  cask.installed:
    - name: {{app}}
{% endfor %}

{% set brewapps = salt['pillar.get']("brew_apps", []) %}
{% for app in brewapps %}
{%   if app is mapping -%}
{%     for name, options in app.items() -%}
brew {{name}}:
  pkg.installed:
    - name: {{name}}
{%       for opname, opval in options.items() %}
    - {{opname}}: {{opval}}
{%       endfor %}
{%     endfor -%}
{%   else -%}
brew {{app}}:
  pkg.installed:
    - name: {{app}}
{%   endif %}
{% endfor %}
