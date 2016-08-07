include:
  - .apps

key repeat from karabiner:
  mac_param.modify:
    - domain: "org.pqrs.Karabiner"
    - kIsOverwriteKeyRepeat: 1

Default profile:
  karabiner.profile:
    - name: Default
    - repeat.wait: 42
    - repeat.initial_wait: 401

Office profile:
  karabiner.profile:
    - name: Office
    - repeat.wait: 42
    - repeat.initial_wait: 401
    - remap.option_equal_to_command_backquote: 1
    - remap.uk_backslash2hash: 1
    - remap.uk_section2backslash: 1
    - remap.uk_swap_at_doublequote: 1
