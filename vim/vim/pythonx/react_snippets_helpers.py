import re
import os

def _camel_case(word):
    cc_parts = [x[0].upper() + x[1:] for x in re.split("(?:_|-|\s)+", word)]
    return ''.join(cc_parts)

def _filter_dir_name(name):
    if re.match(r"__tests?__", name): return False
    if re.match(r"[^/]*\.js$", name): return False
    return True

def _directory(path):
    parts = os.path.dirname(path).split(os.sep)
    parts = [x for x in parts if _filter_dir_name(x)]

    return parts.pop()


def _subject_name(path):
  """
  return the subject name in test, function or component file
  """
  subject = os.path.basename(path)
  subject = subject.replace('-test', '')
  subject = subject.replace('-spec', '')
  subject = subject.replace('-unit', '')
  subject = subject.replace('.test', '')
  subject = subject.replace('.spec', '')
  subject = subject.replace('.unit', '')
  subject = subject.replace('.acceptance', '')
  subject = subject.split('.')[0]

  if subject == "index":
      # use the parent directory's name
      subject = _directory(path)

  return subject

def component_name(path):
  """
  return the component name in test or component file
  """
  return _camel_case(_subject_name(path))

def subject_relative_path(path):
  """
  return the subject relative path from current file
  there is no magic, for now it only replaces __tests__ with ../
  """
  directory = path
  subject = component_name(path)

  filename = os.path.basename(path)
  directory = os.path.dirname(path)
  parent = os.path.basename(directory)

  if re.match(r"index(?:[-._](?:spec|unit|test|acceptance))?\.jsx?$", filename):
    if re.match(r"__tests?__/?", parent):
      return '..' + os.sep
    return '.' + os.sep

  if re.match(r"__tests?__/?", parent):
    return '..' + os.sep

  return os.path.join('.', subject)

def subject_fully_qualified_path(path):
  """
  return the subject path relative to src
  """
  directory = path
  subject = component_name(path)

  filename = os.path.basename(path)
  directory = os.path.dirname(path)
  parent = os.path.basename(directory)

  directory = re.sub(r"^.*src/", '', directory)

  if re.match(r"index(?:[-._](?:spec|unit|test|acceptance))?\.jsx?$", filename):
    if re.match(r"__tests?__/?", parent):
      return os.path.dirname(directory)
    return directory

  if re.match(r"__tests?__/?", parent):
    return os.path.dirname(directory)

  return os.path.join(directory, subject)

if __name__ == '__main__':
    import unittest

    class Snip(object):
        def __init__(self, **kwargs):
            defaultProps = {
                    'basename': 'foo/component.js'
                    }
            for key, value in defaultProps.iteritems():
                setattr(self, key, value)
            for key, value in kwargs.iteritems():
                setattr(self, key, value)

    class TestStringMethods(unittest.TestCase):
        def test__subject_name(self):
            self.assertEqual(_subject_name('some/path/MyComponent.js'), 'MyComponent')
            self.assertEqual(_subject_name('some/path/MyComponent/index.js'), 'MyComponent')
            self.assertEqual(_subject_name('some/path/my-component.js'), 'my-component')
            self.assertEqual(_subject_name('some/path/my-component-unit.js'), 'my-component')
            self.assertEqual(_subject_name('some/path/my-component-test.js'), 'my-component')
            self.assertEqual(_subject_name('some/path/my-component-spec.js'), 'my-component')
            self.assertEqual(_subject_name('some/path/my-component.unit.js'), 'my-component')
            self.assertEqual(_subject_name('some/path/my-component.test.js'), 'my-component')
            self.assertEqual(_subject_name('some/path/my-component.spec.js'), 'my-component')

        def test_component_name(self):
            self.assertEqual(component_name('some/path/MyComponent.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/MyComponent/index.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/MyComponent/__tests__/index.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/MyComponent/__test__/index.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my_component.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component-unit.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component-test.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component-spec.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component.unit.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component.test.js'), 'MyComponent')
            self.assertEqual(component_name('some/path/my-component.spec.js'), 'MyComponent')

        def test_subject_relative_path(self):
            self.assertEqual(subject_relative_path('some/path/MyComponent.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/MyComponent/index.js'), './')
            self.assertEqual(subject_relative_path('some/path/MyComponent/index-test.js'), './')
            self.assertEqual(subject_relative_path('some/path/MyComponent/__tests__/index.js'), '../')
            self.assertEqual(subject_relative_path('some/path/MyComponent/__tests__/my-component.unit.js'), '../')
            self.assertEqual(subject_relative_path('some/path/MyComponent/__test__/index.js'), '../')
            self.assertEqual(subject_relative_path('some/path/my-component.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/my-component-unit.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/my-component-test.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/MyComponent-test.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/my-component-spec.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/my-component.unit.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/my-component-container.unit.js'), './MyComponentContainer')
            self.assertEqual(subject_relative_path('some/path/my-component.test.js'), './MyComponent')
            self.assertEqual(subject_relative_path('some/path/my-component.spec.js'), './MyComponent')

        def test_subject_fully_qualified_path(self):
            self.assertEqual(
                subject_fully_qualified_path('some/path/MyComponent.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/path/MyComponent/index.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/path/MyComponent/__tests__/index.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/path/MyComponent/__tests__/my-component.unit.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/path/MyComponent/__tests__/index.unit.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/path/MyComponent/__test__/index.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/src/path/MyComponent/__test__/index.js'),
                'path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('src/some/path/MyComponent/__test__/index.js'),
                'some/path/MyComponent')
            self.assertEqual(
                subject_fully_qualified_path('some/path/my-component.js'),
                'some/path/MyComponent')


    unittest.main()
