import salt.utils


def profile(name, **params):
    profiles = __salt__['karabiner.list_profiles']().split()
    for key, value in params.iteritems():
      params[key] = str(value)
    if name in profiles and len(params) == 0:
        return {'name': name,
                'changes': {},
                'result': True,
                'comment': 'No new profiles, and no params'}
    if name in profiles:
        old_params = __salt__['karabiner.get_params'](name)
        changes = {}
	for key, value in params.iteritems():
            if value != str(old_params.get(key, "")):
	        changes[name + "." + key] = {'old': old_params.get(key, ""), 'new': value}
        
        if len(changes) == 0:
           return {'name': name,
                   'changes': {},
                   'result': None,
                   'comment': 'No changes'}
    else:
	changes = {}
	for key, value in params.iteritems():
            changes[name + "." + key] = {'old': '', 'new': value}
    if __opts__['test']:
       comment = ('Adding profile ' + name) if name not in profiles \
          else name + " params: " + str(params)
       return {'name': name,
               'changes': changes,
               'result': None,
               'comment': comment}
    if name not in profiles:
        __salt__['karabiner.append_profile'](name)
    for key, value in changes.iteritems():
        __salt__['karabiner.set_param'](name, key[len(name) + 1:], value['new'])
    if len(changes) > 0:
        __salt__['karabiner.relaunch']()
    return {'name': name,
            'changes': changes,
            'result': True,
            'comment': 'following changes: ' + str(changes)}
