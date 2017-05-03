{% set caskapps = salt['pillar.get']("cask_apps", []) %}

{% if grains['os_family'] == "Debian" %}
salt packages:
  pkg.installed:
    - pkgs: ['python-software-properties', 'python-apt']
{% endif %}


{% for name, repo in salt['pillar.get']('repos', {}).items() -%}
{{name}} repo:
  pkgrepo.managed:
    - name: {{name}}
    - humanname: {{name}}
{%   for item in repo %}
{%   for key, value in item.items() %}
    - {{key}}: {{value}}
{%   endfor %}
{%   endfor %}
{% endfor %}

{% for app in caskapps %}
{{app}}:
  cask.installed:
    - name: {{app}}
{% endfor %}

{% set brewapps = salt['pillar.get']("brew_apps", []) %}
{% for app in brewapps %}
{%   if app is mapping -%}
{%     for name, options in app.items() -%}
{{name}}:
  pkg.installed:
    - name: {{name}}
{%       for opname, opval in options.items() %}
    - {{opname}}: {{opval}}
{%       endfor %}
{%     endfor -%}
{%   else -%}
{{app}}:
  pkg.installed:
    - name: {{app}}
{%   endif %}
{% endfor %}

{% set mint_apps = salt['pillar.get']("mint_apps", []) %}
{% if mint_apps %}
mint apps:
  pkg.latest:
    - pkgs: {{mint_apps}}
    - refresh: True
{% endif %}
