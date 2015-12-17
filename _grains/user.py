def _shell():
  from os import environ
  return {'shell': environ['SHELL']}
def _user():
  from getpass import getuser
  return {'user': getuser()}

def main():
  grains = {}
  grains.update(_user())
  grains.update(_shell())
  return grains
