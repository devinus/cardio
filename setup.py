from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

extensions = [
    Extension("cardio", ["cardio.pyx"],
        language="c++",
        library_dirs = ['.'],
        libraries = ['dmz']
    )
]

setup(
    name = 'Cardio',
    ext_modules = cythonize(extensions)
)
