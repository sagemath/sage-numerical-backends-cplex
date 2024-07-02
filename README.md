# sage-numerical-backends-cplex: CPLEX mixed integer linear programming backend for SageMath

[![PyPI](https://img.shields.io/pypi/v/sage-numerical-backends-cplex)](https://pypi.org/project/sage-numerical-backends-cplex/ "PyPI: sage-numerical-backends-cplex")

Prior to SageMath 9.1, `CPLEXBackend` was available as part of the [SageMath](http://www.sagemath.org/) source tree,
from which it would be built as an "optional extension" if the proprietary CPLEX library and header files have been symlinked into `$SAGE_LOCAL` manually.

Because of the proprietary nature of the CPLEX software, `CPLEXBackend` is not available in any binary distributions of SageMath.

The present standalone Python package `sage-numerical-backends-cplex` has been created from the SageMath sources, version 9.0.beta10; the in-tree version of `CPLEXBackend` has been removed in Sage ticket https://trac.sagemath.org/ticket/28175.  SageMath 9.1 and later makes the package available as an optional Sage package (SPKG).

The current version of this package can also be installed on top of various Sage installations using pip.
(Your installation of Sage must be based on Python 3; if your SageMath is version 9.2 or newer, it is.)


## Installation of CPLEX

[CPLEX](https://www.ibm.com/products/ilog-cplex-optimization-studio)
is proprietary software.  It is available for free for researchers and students through IBM's Academic Initiative.

Install CPLEX according to the instructions on the website.

To prepare installation of `sage-numerical-backends-cplex`, find the installation directory of your ILOG CPLEX Studio installation, which contains subdirectories ``cplex``, ``doc``, ``opl``, etc. Set the environment variable ``CPLEX_HOME`` to this directory; for example using the following shell command (on macOS):

        $ export CPLEX_HOME=/Applications/CPLEX_Studio1210

or (on Linux):

        $ export CPLEX_HOME=/opt/ibm/ILOG/CPLEX_Studio1210

Now verify that the CPLEX binary that you will find in the subdirectory ``cplex/bin/ARCH_OS`` starts correctly, for example::

    $ $CPLEX_HOME/cplex/bin/x86-64_osx/cplex
    Welcome to IBM(R) ILOG(R) CPLEX(R) Interactive Optimizer...

(Alternatively, set compiler/linker flags (or use symbolic links) so that `cplex.h` and `libcplex.so` can be found.)

## Installation of the version of this package shipped by SageMath 9.1 or later

This package is prepared as an optional Sage package (SPKG) in SageMath 9.1 or later.
To install it, use

        $ sage -i sage_numerical_backends_cplex

After a successful installation, Sage will automatically make this new backend
the default MIP solver.

## Installation of the current version of this package in an existing installation of SageMath

Install this package from PyPI using

    $ sage -pip install sage-numerical-backends-cplex

or from a checked out source tree using

    $ sage -pip install .

or from GitHub using

    $ sage -pip install git+https://github.com/sagemath/sage-numerical-backends-cplex

(See [`build.yml` in the related package sage-numerical-backends-coin package](https://github.com/sagemath/sage-numerical-backends-coin/blob/master/.github/workflows/build.yml) for details about package prerequisites on various systems.)

## Running doctests

To run the (limited) testsuite of this package, use:

    $ sage setup.py test

To run the Sage testsuite with the default MIP solver set to the backend provided by this package, use:

    $ sage setup.py check_sage_testsuite
