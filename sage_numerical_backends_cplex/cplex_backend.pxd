# ****************************************************************************
#       Copyright (C) 2010 Nathann Cohen <nathann.cohen@gmail.com>
#                     2019 David Coudert <david.coudert@inria.fr>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#                  https://www.gnu.org/licenses/
# ****************************************************************************

from sage.numerical.backends.generic_backend cimport GenericBackend

cdef extern from "stdio.h":
    ctypedef struct FILE
    FILE * fopen (const char * filename, const char * opentype)

cdef extern from "cplex.h":
    struct cpxenv
    struct cpxlp

ctypedef cpxenv c_cpxenv
ctypedef cpxlp c_cpxlp

cdef class CPLEXBackend(GenericBackend):
    cdef bint _mixed
    cdef c_cpxenv * env
    cdef c_cpxlp * lp
    cdef current_sol
    cdef str _logfilename
    cpdef __copy__(self)

cdef extern from "cplex.h":

     # Create problem
     c_cpxlp * CPXcreateprob(c_cpxenv *  env, int *status_p,
                             char *probname_str)

     # Add constraints
     int CPXaddrows(c_cpxenv * env, c_cpxlp *  lp, int ccnt, int rcnt,
                   int nzcnt, double *rhs, char *sense,
                   int *rmatbeg, int *rmatind,
                   double *rmatval, char **colname,
                   char **rowname)

     # Remove constraints
     int CPXdelrows(c_cpxenv * env, c_cpxlp * lp, int begin, int end)

     # Solve MILP
     int CPXmipopt(c_cpxenv * env, c_cpxlp * lp)

     # Solve LP
     int CPXlpopt(c_cpxenv * env, c_cpxlp * lp)

     # Get solution status
     int CPXgetstat(c_cpxenv * env, c_cpxlp * lp)

     # Solve MILP through filling the solution pool
     int CPXpopulate(c_cpxenv * env, c_cpxlp * lp)

     # Number of solutions in the pool
     int CPXgetsolnpoolx(c_cpxenv * env, c_cpxlp * lp, int id, double * x, int beg, int end)

     # Set the sense of the optimization problem
     int CPXchgobjsen(c_cpxenv * env, c_cpxlp * lp, int)

     # Gets the sense of the optimization problem
     int CPXgetobjsen(c_cpxenv * env, c_cpxlp * lp)

     # Change the coefficient of a variable in the objective function
     int CPXchgobj(c_cpxenv * env, c_cpxlp * lp, int cnt, int * indices, double * values)

     # Sets the problem's name
     int CPXchgprobname(c_cpxenv * env, c_cpxlp * lp, char * probname_str)

     # Gets the problem's name
     int CPXgetprobname(c_cpxenv * env, c_cpxlp * lp, char * buf_str, int bufspace, int * surplus_p)

     # Get a col's name
     int CPXgetcolname(c_cpxenv * env, c_cpxlp * lp, char ** name, char * namestore, int storespace, int * surplus_p, int begin, int end)

     # Get a row's name
     int CPXgetrowname(c_cpxenv * env, c_cpxlp * lp, char ** name, char * namestore, int storespace, int * surplus_p, int begin, int end)

     # Sets a row's name
     int CPXchgrowname(c_cpxenv * env, c_cpxlp * lp, int cnt, int * indices, char ** newname)

     # Sets a col's name
     int CPXchgcolname(c_cpxenv * env, c_cpxlp * lp, int cnt, int * indices, char ** newname)

     # Number of solutions in the pool
     int CPXgetsolnpoolnumsolns(c_cpxenv * env, c_cpxlp * lp)

     # Number of replaces solutions in the pool
     int CPXgetsolnpoolnumreplaced(c_cpxenv * env, c_cpxlp * lp)

     # Remove a solution from the pool
     int CPXdelsolnpoolsolns(c_cpxenv * env, c_cpxlp * lp, int begin, int end)

     int CPXgetsubstat(c_cpxenv * env, c_cpxlp * lp)

     # Get the objective value
     int CPXgetobjval(c_cpxenv *, c_cpxlp *, double *)

     # Get the best objective value (i.e., best lower/upper bound)
     int CPXgetbestobjval(c_cpxenv *, c_cpxlp *, double *)

     # Get MIP relative gap
     int CPXgetmiprelgap(c_cpxenv *, c_cpxlp *, double *)

     # Add columns
     int CPXnewcols(c_cpxenv * env, c_cpxlp * lp, int, double *, double *, double *, char *, char **)

     # Add rows
     int CPXnewrows(c_cpxenv * env, c_cpxlp * lp, int rcnt, double * rhs, char * sense, double * rngval, char ** rowname)

     # Get the right hand side of a row
     int CPXgetrhs(c_cpxenv * env, c_cpxlp * lp, double * rhs, int begin, int end)

     # Get the sense of a constraint
     int CPXgetsense(c_cpxenv * env, c_cpxlp * lp, char * sense, int begin, int end)

     # Get rows
     int CPXgetrows(c_cpxenv * env, c_cpxlp * lp, int * nzcnt_p, int * rmatbeg, int * rmatind, double * rmatval, int rmatspace, int * surplus_p, int begin, int end)

     # Get a variable's maximum value
     int CPXgetub(c_cpxenv * env, c_cpxlp * lp, double * ub, int begin, int end)

     # Get a variable's minimum value
     int CPXgetlb(c_cpxenv * env, c_cpxlp * lp, double * lb, int begin, int end)

     # Changes the bounds of a variable
     int CPXchgbds(c_cpxenv * env, c_cpxlp * lp, int cnt, int * indices, char * lu, double * bd)

     # Get a coefficient of the objective function
     int CPXgetobj(c_cpxenv * env, c_cpxlp * lp, double * obj, int begin, int end)

     # Change coefficients in the matrix
     int CPXchgcoeflist(c_cpxenv * env, c_cpxlp * lp, int numcoefs, int * rowlist, int * collist, double * vallist)

     # get solution of a MILP
     int CPXsolution(c_cpxenv * env, c_cpxlp * lp, int * lpstat, double * obj, double * x, double *, double *, double *)

     # get the value of some variables in the solution of a LP
     int CPXgetx(c_cpxenv * env, c_cpxlp * lp, double * x, int begin, int end)

     # Create a CPLEX environment
     c_cpxenv * CPXopenCPLEX(int *status_p)

     # Close a CPLEX environment
     int CPXcloseCPLEX(c_cpxenv ** env)

     # Free the problem's ressources
     int CPXfreeprob(c_cpxenv * env, c_cpxlp ** lp)

     # Change the type of a variable
     int CPXchgctype(c_cpxenv * env, c_cpxlp * lp, int cnt, int * indices, char * xctype)

     # Gets the type of a variable
     int CPXgetctype(c_cpxenv * env, c_cpxlp * lp, char * xctype, int begin, int end)

     # Get information about the solution computed
     int CPXsolninfo(c_cpxenv * env, c_cpxlp * lp, int * solnmethod_p, int * solntype_p, int * pfeasind_p, int * dfeasind_p)

     # Returns the number of rows
     int CPXgetnumrows(c_cpxenv * env, c_cpxlp * lp)

     # Returns the number of columns
     int CPXgetnumcols(c_cpxenv * env, c_cpxlp * lp)

     # Write the problem to a file
     int CPXwriteprob(c_cpxenv * env, c_cpxlp * lp, char * filename_str, char * filetype_str)

     # Get the problem's type
     int CPXgetprobtype(c_cpxenv * env, c_cpxlp * lp)

     # Set the problem's type
     int CPXchgprobtype(c_cpxenv * env, c_cpxlp * lp, int type)

     # Change a row's range
     int CPXchgrngval(c_cpxenv * env, c_cpxlp * lp, int cnt, int * indices, double * values)

     # Get a row's range
     int CPXgetrngval(c_cpxenv * env, c_cpxlp * lp, double * rngval, int begin, int end)

     # Copy a LP
     c_cpxlp * CPXcloneprob(c_cpxenv * env, c_cpxlp * lp, int * status_p)

     # Gets the type of a CPLEX parameter
     int CPXgetparamtype(c_cpxenv * env, int paramid, int * paramtype)

     # Returns the value of an integer prameter
     int CPXgetintparam(c_cpxenv * env, int paramid, int * intv)

     # Returns the value of a double prameter
     int CPXgetdblparam(c_cpxenv * env, int paramid, double * doublev)

     # Returns the value of a string prameter
     int CPXgetstrparam(c_cpxenv * env, int paramid, char * strv)

     # Returns the value of a string prameter
     int CPXgetlongparam(c_cpxenv * env, int paramid, long long * longv)

     # Sets the value of an integer parameter
     int CPXsetintparam(c_cpxenv * env, int paramid, int value)

     # Sets the value of a double parameter
     int CPXsetdblparam(c_cpxenv * env, int paramid, double value)

     # Sets the value of a string parameter
     int CPXsetstrparam(c_cpxenv * env, int paramid, char * value)

     # Sets the value of a long parameter
     int CPXsetlongparam(c_cpxenv * env, int paramid, long value)

     # Set the log file
     int CPXsetlogfilename(c_cpxenv * env, char * filename, char * mode)

     # CONSTANTS
     int CPX_ON = 1
     int CPX_PARAM_SCRIND = 1035
     double CPX_INFBOUND = 1.0E+20
     int CPX_PARAM_POPULATELIM = 2108
     int CPX_PARAM_SOLNPOOLGAP = 2105
     int CPX_PARAM_SOLNPOOLINTENSITY = 2107
     int CPX_MAX = -1
     int CPX_MIN = 1

cdef extern from "cpxconst.h":

     # Solution quality
     #
     # The problem either has a simplex basis
     int CPX_BASIC_SOLN

     # The problem has a primal and dual solution but no basis
     int CPX_NONBASIC_SOLN

     # The problem has a primal solution but no corresponding dual solution
     int CPX_PRIMAL_SOLN

     # The problem has no solution
     int CPX_NO_SOLN

     # Solution status
     int CPX_STAT_OPTIMAL
     int CPX_STAT_INFEASIBLE
     int CPX_STAT_UNBOUNDED
     int CPX_STAT_INForUNBD

     int CPXMIP_OPTIMAL
     int CPXMIP_INFEASIBLE
     int CPXMIP_UNBOUNDED
     int CPXMIP_INForUNBD

