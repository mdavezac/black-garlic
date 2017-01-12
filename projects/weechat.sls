# expects a few pillars in secrets.sls:
#
# weechat_tokens:
#   room: token
#

{% set project = sls.split('.')[-1] %}
{% set python = salt['pillar.get']('python', 'python2') %}
{% set workspace = salt['funwith.workspace'](project) %}
{% set tokens = ",".join(salt['pillar.get']('weechat_tokens', {}).values()) %}

{{grains['userhome']}}/.weechat/python/autoload/wee_slack.py:
  file.managed:
    - source: https://raw.githubusercontent.com/rawdigits/wee-slack/master/wee_slack.py
    - source_hash: md5=925adcf8fc6091ea3bc964482a3ba091
    - makedirs: true

{{project}} aspell:
  pkg.installed:
    - name: aspell
    - options: ['--with-lang-uk']

{{project}} weechat:
  pkg.installed:
    - name: weechat
    - options: ['--with-python', '--with-aspell', '--with-perl', '--with-ruby', '--with-lua']

{{project}} websocket-client:
  cmd.run:
    - name: /usr/local/bin/{{python}} -m pip install --upgrade websocket-client

weechat setup:
  cmd.run:
    - name: |
        weechat -r "/set plugins.var.python.slack_extension.slack_api_token {{tokens}};/save;/quit"
#       weechat -r "/set weechat.bar.status.color_bg 22;/save/quit"
#       weechat -r "/set weechat.bar.title.color_bg 22;/save/quit"

{{project}} modulefile:
  funwith.modulefile:
    - name: {{project}}
    - workspace: {{workspace}}

{{grains['userhome']}}/.tmuxinator/{{project}}.yml:
  file.managed:
    - contents: |
        name: {{project}}
        root: {{workspace}}
        windows:
          - {{project}}:
              layout: "main-horizontal"
              panes:
                - weechat:
                  - module load {{project}}
                  - fc -R
                  - weechat
