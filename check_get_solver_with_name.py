from __future__ import print_function
# Check that the backend can be obtained by passing solver='cplex' to get_solver.
from sage.numerical.backends.generic_backend import get_solver
from sage_numerical_backends_cplex.cplex_backend import CPLEXBackend
b = get_solver(solver='cplex')
assert type(b) == CPLEXBackend, "get_solver(solver='cplex') does not give an instance of sage_numerical_backends_cplex.cplex_backend.CPLEXBackend"
print("Success: get_solver(solver='cplex') gives {}".format(b))
