#! /usr/bin/env python
## -*- encoding: utf-8 -*-

from __future__ import print_function

import os
import sys
import subprocess
from setuptools import setup
from setuptools import Extension
from setuptools.command.test import test as TestCommand # for tests
from Cython.Build import cythonize
from codecs import open # To open the README file with proper encoding
from sage.env import sage_include_directories

# For the tests
class SageTest(TestCommand):
    def run_tests(self):
        errno = os.system("sage -t --force-lib sage_numerical_backends_cplex")
        if errno != 0:
            sys.exit(1)

# Get information from separate files (README, VERSION)
def readfile(filename):
    with open(filename, encoding='utf-8') as f:
        return f.read()

cplex_include_directories = []
cplex_lib_directories = []
cplex_libs = []
cplex_home = os.getenv("CPLEX_HOME")

exts = ['so']
if sys.platform == 'darwin':
    cplex_platform = 'x86-64_osx'
    exts.insert(0, 'dylib')
else:
    cplex_platform = 'x86-64_linux'

if cplex_home:
    cplex_include_directories.append(cplex_home + "/include/ilcplex")
    libdir = cplex_home + "/bin/" + cplex_platform
    cplex_lib_directories.append(libdir)
    from fnmatch import fnmatch
    for file in os.listdir(libdir):
        if any(fnmatch(file, 'libcplex[0-9]*[0-9].' + ext) for ext in exts):
            cplex_libs = [os.path.splitext(file)[0][3:]]
            if sys.platform == 'darwin':
                # the .dylib uses @rpath.
                os.environ["LDFLAGS"] = os.environ.get("LDFLAGS", "") + " -rpath " + libdir
            break

if not cplex_libs:
    print("CPLEX_HOME is not set, or it does not point to a directory with a "
          "Cplex installation.  Trying to link against -lcplex", file=sys.stderr)
    cplex_libs = ['cplex']
else:
    print("Using cplex_include_directories={}, libraries={}, library_dirs={}".format(
        cplex_include_directories, cplex_libs, cplex_lib_directories), file=sys.stderr)

 # Cython modules
ext_modules = [Extension('sage_numerical_backends_cplex.cplex_backend',
                         sources = [os.path.join('sage_numerical_backends_cplex',
                                     'cplex_backend.pyx')],
                         include_dirs=sage_include_directories() + cplex_include_directories,
                         libraries=cplex_libs,
                         library_dirs=cplex_lib_directories)
    ]

setup(
    name="sage_numerical_backends_cplex",
    version=readfile("VERSION").strip(),
    description="Cplex backend for Sage MixedIntegerLinearProgram",
    long_description = readfile("README.md"), # get the long description from the README
    long_description_content_type='text/markdown', # https://packaging.python.org/guides/making-a-pypi-friendly-readme/
    url="https://github.com/mkoeppe/sage-numerical-backends-cplex",
    # Author list obtained by running the following command on sage 9.0.beta9:
    # for f in cplex_backend.p*; do git blame -w -M -C -C --line-porcelain "$f" | grep -I '^author '; done | sort -f | uniq -ic | sort -n
    # cut off at < 10 lines of attribution.
    author='Nathann Cohen, David Coudert, Matthias Koeppe, Martin Albrecht, John Perry, Jeroen Demeyer, Jori Mäntysalo, Erik M. Bray, and others',
    author_email='mkoeppe@math.ucdavis.edu',
    license='GPLv2+', # This should be consistent with the LICENCE file
    classifiers=['Development Status :: 5 - Production/Stable',
                 "Intended Audience :: Science/Research",
                 'License :: OSI Approved :: GNU General Public License v2 or later (GPLv2+)',
                 "Programming Language :: Python",
                 "Programming Language :: Python :: 2",
                 'Programming Language :: Python :: 2.7',
                 'Programming Language :: Python :: 3',
                 'Programming Language :: Python :: 3.4',
                 'Programming Language :: Python :: 3.5',
                 'Programming Language :: Python :: 3.6',
                 'Programming Language :: Python :: 3.7',
                 ],
    ext_modules = cythonize(ext_modules, include_path=sys.path),
    cmdclass = {'test': SageTest}, # adding a special setup command for tests
    keywords=['milp', 'linear-programming', 'optimization'],
    packages=['sage_numerical_backends_cplex'],
    package_dir={'sage_numerical_backends_cplex': 'sage_numerical_backends_cplex'},
    package_data={'sage_numerical_backends_cplex': ['*.pxd']},
    install_requires = ['sage>=8', 'sage-package', 'sphinx'],
)
