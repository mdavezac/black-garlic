# -*- coding: utf-8 -*-
'''
Mac-OS/X setup
'''
from __future__ import absolute_import

# Import python libs
import copy
import logging

# Import salt libs
import salt.utils
from salt.exceptions import CommandExecutionError, MinionError

log = logging.getLogger(__name__)

def set_param(key, value, domain=""):
    cmd = "defaults write " + domain + " " + key + " " + str(value)
    return __salt__['cmd.run_all'](cmd, output_loglevel='trace', python_shell=False)['stdout']

def get_param(key="", domain=""):
    cmd = "defaults read \"" + domain + "\" " + key
    return __salt__['cmd.run_all'](cmd, output_loglevel='trace', python_shell=False)['stdout']
