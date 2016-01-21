def _shell():
  from os import environ
  return {'shell': environ['SHELL']}
def _user():
  from getpass import getuser
  return {'user': getuser()}
def _home():
  from getpass import getuser
  from os.path import expanduser
  return {'userhome': expanduser("~" + getuser())}

def condiment_dir():
    from os.path import dirname
    return dirname(__file__)

def main():
  grains = {}
  grains.update(_user())
  grains.update(_shell())
  grains.update(_home())
  grains['condiment_dir'] = condiment_dir()
  return grains
