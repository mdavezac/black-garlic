{% set salted = salt['pillar.get']('zsh:salted', grains['userhome'] + "/.salted") %}

CMake completions:
  file.managed:
    - name: {{salted}}/completions/_cmake
    - source: https://raw.githubusercontent.com/skroll/zsh-cmake-completion/master/_cmake
    - source_hash: sha1=e1ecae244d4ea02c457b5fdfe60adcd294968054
    - makedirs: true

{% for completion in salt['pillar.get']('zsh:completions', {}) %}
{{salted}}/completions/_{{completion.keys() | first}}:
  file.managed:
    - makedirs: true
    - contents: |-
        #compdef {{completion.keys() | first}}
        {{completion.values() | first}}
{% endfor %}
