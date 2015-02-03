from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

extensions = [
    Extension("cardio", ["cardio.pyx"],
        language="c++",
        include_dirs = ['dmz'],
        library_dirs = ['.'],
        libraries = ['dmz'],
        define_macros = [('CYTHON_DMZ', 1), ('SCAN_EXPIRY', 1)]
    )
]

setup(
    name = 'Cardio',
    ext_modules = cythonize(extensions)
)
