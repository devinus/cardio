from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

extensions = [
    Extension("cardio", ["cardio.pyx"], libraries = ['dmz'], library_dirs = ['.'])
]

setup(
  name = 'Cardio',
  ext_modules = cythonize(extensions)
)
