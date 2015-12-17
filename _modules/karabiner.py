# -*- coding: utf-8 -*-
'''
Karabiner setup
'''
from __future__ import absolute_import

# Import python libs
import copy
import logging

# Import salt libs
import salt.utils
from salt.exceptions import CommandExecutionError, MinionError

log = logging.getLogger(__name__)

cli = "/Applications/Karabiner.app/Contents/Library/bin/karabiner"
""" Command-line application """

def list_profiles(**kwargs):
    ''' List current profiles '''
    cmd = cli + " list"
    return __salt__['cmd.run_all'](cmd,
                                   output_loglevel='trace',
                                   python_shell=False)['stdout']

def selected():
    cmd = cli + " selected"
    return __salt__['cmd.run_all'](cmd,
                                   output_loglevel='trace',
                                   python_shell=False)['stdout']

def select(name):
    try:
      cmd = cli + " select " + str(int(name))
    except:
      cmd = cli + " select_by_name " + str(name)
    return __salt__['cmd.run_all'](cmd,
                                   output_loglevel='trace',
                                   python_shell=False)['stdout']
  
def set_param(profile, key, value):
    original = selected()
    try:
        select(profile)
        return __salt__['cmd.run_all'](cli + " set " + key + " " + str(value),
                                       output_loglevel='trace',
                                       python_shell=False)['stdout']
    finally:
        select(original)

def get_params(profile='Default'):
    original = selected()
    try:
        select(profile)
        output = __salt__['cmd.run_all'](cli + " changed",
                                         output_loglevel='trace',
                                         python_shell=False)['stdout']
        
        result = {}
        for line in output.split('\n'):
          key, value = line.split('=')
          if not key.startswith('notsave'):
            result[key] = value
        return result
    finally:
        select(original)
    
def relaunch():
  __salt__['cmd.run'](cli + " relaunch")

  
def append_profile(name, **kwargs):
    cmd = cli + " append  " + name
    return __salt__['cmd.run_all'](cmd,
                                   output_loglevel='trace',
                                   python_shell=False)
