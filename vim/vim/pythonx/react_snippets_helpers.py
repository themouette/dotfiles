import re

def subject_name(snip):
  """
  return the subject name in test, function or component file
  """
  subject = snip.basename.replace('-test', '').split('.')[0]
  return subject

def component_name(snip):
  """
  return the component name in test or component file
  """
  subject = subject_name(snip)
  return subject[0].upper() + subject[1:]

def subject_relative_path(snip, path):
  """
  return the subject relative path from current file
  there is no magic, for now it only replaces __tests__ with ../
  """
  fullPath = re.sub(r"^.*__tests?__/?", '../', path)
  fullPath = re.sub(r"[^/]*\.js$", '', fullPath)
  fullPath = fullPath if len(fullPath) else './'
  return fullPath + subject_name(snip)

def subject_fully_qualified_path(snip, path):
  """
  return the subject path relative to src
  """
  fullPath = re.sub(r"__tests?__/?", '', path)
  fullPath = re.sub(r"^.*src/", '', fullPath)
  fullPath = re.sub(r"[^/]*\.js$", '', fullPath)
  fullPath = fullPath if len(fullPath) else './'
  return fullPath + subject_name(snip)

