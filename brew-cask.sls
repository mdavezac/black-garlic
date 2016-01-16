brew-cask:
  cmd.wait:
    - order: 0
    - name: brew tap Caskroom/cask
    - creates: /usr/local/Library/Taps/caskroom/homebrew-cask
#     - require:
#       - file: /usr/local
#   
# /usr/local:
#   file.directory:
#     - order: 0
#     - user: {{grains['user']}}
#     - recurse:
#         - user
