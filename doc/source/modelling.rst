Modelling
=========

DAEs
----
DAEs are a system of differential equations in one independent variable.  In DAEs, the derivatives of some dependent variables might not explicitly appear.

The system of DAES can be converted to a system of ODEs (where the derivatives are explicit) by differentiating the equations with respect to the independent variable.  The number of times they need to be differentiated to convert to a system of ODEs provides the index.  To solve a system of DAEs they are typically first reduced to an index of 1 (often more efficient than fully converting to ODE and solving), although techniques for solving high index DAEs also exist.  For more information see `wolfram <http://reference.wolfram.com/language/tutorial/NDSolveDAE.html>`__ or `wikipedia <https://en.wikipedia.org/wiki/Differential_algebraic_equation>`__.

The primary solver used by OpenModelica for solving index 1 or less DAEs is DASSL.  Some information on the solver is provided `here <http://www.dm.uniba.it/~testset/report/dassl.pdf>`__.  Another popular DAE solver is `IDA <https://computation.llnl.gov/casc/sundials/main.html>`__ (which is derived from DASPK).

PDEs
----
OpenModelica can only solve DAEs or ODEs, so one of a number of different approximation methods will be required for any PDEs:

* Finite difference method
* Finite element method
* Finite volume method
* Weak form

Discrete Events
---------------
Have to make sure the number of equations is equal to the number of variables at all times.
