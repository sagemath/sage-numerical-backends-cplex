# sage-numerical-backends-cplex: CPLEX mixed integer linear programming backend for SageMath

[![PyPI](https://img.shields.io/pypi/v/sage-numerical-backends-cplex)](https://pypi.org/project/sage-numerical-backends-cplex/ "PyPI: sage-numerical-backends-cplex")

Prior to SageMath 9.1, `CPLEXBackend` was available as part of the [SageMath](http://www.sagemath.org/) source tree,
from which it would be built as an "optional extension" if the proprietary CPLEX library and header files have been symlinked into `$SAGE_LOCAL` manually.

Because of the proprietary nature of the CPLEX software, `CPLEXBackend` is not available in any binary distributions of SageMath.

The present standalone Python package `sage-numerical-backends-cplex` has been created from the SageMath sources, version 9.0.beta10; the in-tree version of `CPLEXBackend` has been removed in Sage ticket https://trac.sagemath.org/ticket/28175.  

The package can be installed on top of various Sage installations using pip, including older versions of Sage such as 8.1 (as shipped by Ubuntu bionic 18.04LTS).  SageMath 9.1 and later makes the package available as an optional Sage package (SPKG).

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

## Installation of this package in SageMath 9.1 or later

This package is prepared as an optional Sage package (SPKG) in SageMath 9.1 or later.
To install it, use

        $ sage -i sage_numerical_backends_cplex

After a successful installation, Sage will automatically make this new backend
the default MIP solver.

## Installation of this package in older versions of SageMath

Install this package from PyPI using

    $ sage -python -m pip install sage-numerical-backends-cplex

or from a checked out source tree using

    $ sage -python -m pip install .

or from GitHub using

    $ sage -python -m pip install git+https://github.com/mkoeppe/sage-numerical-backends-cplex

(See [`build.yml` in the related package sage-numerical-backends-coin package](https://github.com/mkoeppe/sage-numerical-backends-coin/blob/master/.github/workflows/build.yml) for details about package prerequisites on various systems.)

### Using this package in older versions of SageMath

To obtain a solver (backend) instance:

    sage: from sage_numerical_backends_cplex.cplex_backend import CPLEXBackend
    sage: CPLEXBackend()
    <sage_numerical_backends_cplex.cplex_backend.CPLEXBackend object at 0x7fb72c2c7528>

Equivalently:

    sage: from sage_numerical_backends_cplex.cplex_backend import CPLEXBackend
    sage: from sage.numerical.backends.generic_backend import get_solver
    sage: get_solver(solver=CPLEXBackend)
    <sage_numerical_backends_cplex.cplex_backend.CPLEXBackend object at 0x7fe21ffbe2b8>

To use this solver (backend) with [`MixedIntegerLinearProgram`](http://doc.sagemath.org/html/en/reference/numerical/sage/numerical/mip.html):

    sage: from sage_numerical_backends_cplex.cplex_backend import CPLEXBackend
    sage: M = MixedIntegerLinearProgram(solver=CPLEXBackend)
    sage: M.get_backend()
    <sage_numerical_backends_cplex.cplex_backend.CPLEXBackend object at 0x7fb72c2c7868>

To make it available as the solver named `'CPLEX'`, we need to make the new module
known as `sage.numerical.backends.cplex_backend` (note dots, not underscores), using
the following commands:

    sage: import sage_numerical_backends_cplex.cplex_backend as cplex_backend, sage.numerical.backends as backends, sys
    sage: sys.modules['sage.numerical.backends.cplex_backend'] = backends.cplex_backend = cplex_backend

If these commands are executed in a Sage session before any `MixedIntegerLinearProgram` is created, then
the new `'CPLEX'` solver wins over the `'GLPK'` solver in the selection of the default MIP backend.
To select the `'CPLEX'` solver explicitly as the default MIP backend, additionally use the following command.

    sage: default_mip_solver('CPLEX')

To make these settings permanent, add the above 2 + 1 commands to your `~/.sage/init.sage` file.
Note that this setting will not affect doctesting (`sage -t`) because this file is ignored in doctesting mode.

### Overriding the default solver in older versions of SageMath by patching the Sage installation

Another method is to patch the module in permanently to the sage installation (at your own risk).
This method will affect doctesting.

    $ sage -c 'import os; import sage.numerical.backends as dm; import sage_numerical_backends_cplex.cplex_backend as sm; s = sm.__file__; f = os.path.basename(s); d = os.path.join(dm.__path__[0], f); (os.path.exists(d) or os.path.lexists(d)) and os.remove(d); os.symlink(s, d);'

Or use the script [`patch_into_sage_module.py`](patch_into_sage_module.py) in the source distribution that does the same:

    $ sage -c 'load("patch_into_sage_module.py")'
    Success: Patched in the module as sage.numerical.backends.cplex_backend

Verify with [`check_get_solver_with_name.py`](check_get_solver_with_name.py) that the patching script has worked:

    $ sage -c 'load("check_get_solver_with_name.py")'
    Success: get_solver(solver='cplex') gives <sage_numerical_backends_cplex.cplex_backend.CPLEXBackend object at 0x7f8f20218528>

## Running doctests

To run the (limited) testsuite of this package, use:

    $ sage setup.py test

To run the Sage testsuite with the default MIP solver set to the backend provided by this package, use:

    $ sage setup.py check_sage_testsuite

