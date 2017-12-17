Usage
=====

Note: SolarTherm is currently at an early stage of development.  The instructions provided here will change over time, providing the user with more capabilities.

The basic process for using SolarTherm is to construct a Modelica model of the system, drawing on components from the provided Modelica libraries, and then simulate it using one of the provided scripts.  If required components are missing from the provided libraries, then these can be modelled separately and then integrated into the SolarTherm library.

A full tutorial on the process is provided in a later section. Here we list the different components of the project along with a basic description.

Components
----------
SolarTherm
    A Modelica library containing typical system components required to model a full solar thermal power plant.  Models with varying degrees of complexity are included so that the user can make a trade off between simulation speed and accuracy.

solartherm
    A python library that provides common functions and classes for the other tools to use.

st_simulate
    A python script for simulating a plant model.  It compiles the model, calls the simulation, and post processes the results.  It can also be used for performing parameter sweeps or just changing individual parameters without having to recompile the model each time.

st_optimisation
    A python script for optimising model parameters according to some cost.  Currently this supports the unconstrained methods provided in the scipy library.

st_plotmat
    A python script for easily plotting the results from a simulation.  Behind the scenes it uses the common `matplotlib <http://matplotlib.org>`_ library.

st_inspect
    A python script for converting simulation results into CSV data. Results are output to the console (standard output) but can also be directed into a file (eg `st_inspect myfile.res > output.csv`)

st_wea_to_mo
    A python script for converting TMY3 weather data into a format that is suitable for import into a simulation table.

st_get_aemo_prices
    A python script that downloads spot market prices from `AEMO <http://aemo.com.au/>`_ for a particular year and region, and then converts them into a simulation-table-ready format.

The optimisation tool
----------
Our optimisation tool (i.e. the ``st_optimise`` script) is capable of handling a wide range of optimisation problems in concentrating solar thermal applications. In particular, there are three frameworks implemented for this purpose, namely a single-objective optimisation to either minimise or maximise an objective function and a multi-objective optimisation platform that can handle two or more objectives (the latter can be done with a little bit of tweaking in the codes). For each optimisation framework, our optimisation tool offers several optimisation methods such as Particle Swarm Optimization (PSO), Covariance Matrix Adaptation (CMA), Genetic Algorithm (GA) and one of the SciPy optimisation methods (e.g.  Nelder-Mead, L-BFGS-B, TNC, SLSQP, etc.). It should be noted that the Non-Dominated Sorting Genetic Algorithm II (NSGAII) method is the only optimisation method implemented at the moment for the multi-objective optimisation platform.
In order to utilise our optimisation tool, one should be familiar with a number of key flags defined in the st_optimise command. These flags are:

- The ``--framework`` flag: this flag simply defines which optimisation framework is going to be used, which can be one of single-objective minimisation (``soo_min``), single-objective maximisation (``soo_max``) or multi-objective optimisation (``moo``). One can follow the following format to use this flag after the ``st_optimise`` command::

    --framework=soo_min

- The ``--objective`` flag: this flag is used to select the objective function(s) that are going to be optimised. At the moment, these objectives can be the levelised cost of electricity/fuel (i.e. ``lcoe`` or ``lcof``),  the capacity factor(i.e. ``capf``), the annual electricity/fuel produced per year (``epy`` or ``fpy``) and/or the market spot revenue (``srev``). It is evident that the nature of some of these functions is for minimisation, while the others must be maximised in order to make logical sense. The following example shows how this flag can be used after the ``st_optimise`` command::

    --objective=lcoe,epy

- The ``--method`` flag: this flag specifies which optimisation method is going to be used to conduct the optimisation process. The options can be one of ``pso``, ``cma``, GA from PyEvolve or DEAP packages (i.e. ``ga1`` or ``ga2`` respectively), ``nsga2`` or one of the SciPy optimisation methods. Note that nsga2 is only for multi-objective optimisation problems. The following example shows how this flag can be used after the ``st_optimise`` command::

    --method=pso

- The ``-- fuel`` flag: for those systems producing fuel rather than electricity the ``-- fuel`` flag must be mentioned after the ``st_optimise`` command.

- The ``-- par`` flag: this flag takes the parameters with bounds and optional starting value in form of PNAME=LOW, HIGH [, START]
- The ``-- maxiter`` flag: this flag defines the maximum number of iterations (not necessarily number of simulations).  It should be noted that this flag is only for ``pso``, ``cma`` and SciPye optimisation methods.

- The ``-- dm`` flag: this flags is used to specify the decision-making methods for the multi-objective optimisation framework. The options are ``linmap`` or ``topsis``. In LINMAP method, a solution on the Pareto front curve with the minimum spacial distance from an ideal point (the point at which each single objective has its optimum value regardless of satisfaction of other objectives) is selected as the best optimum design point. In TOPSIS method, in addition to the ideal point, a non-ideal point (the point at which each objective has its worst value) is defined. In fact, the basic principle of this method is that the selected final optimal point must have the shortest distance from the ideal point and the farthest distance from the non-ideal point.

