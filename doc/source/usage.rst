Usage
=====
The basic process for using SolarTherm is to construct a Modelica model of the system, drawing on components from the provided Modelica libraries, and then simulate it using one of the provided scripts.  If required components are missing from the provided libraries, an external model could be integrated into the SolarTherm library.

Here we list the different components of the project along with a basic description. A full tutorial on the process is provided in a later section. 

Note: SolarTherm is still being developed.  The instructions provided here will change over time, providing the user with more capabilities.


Components
^^^^^^^^^^
SolarTherm
    A Modelica library containing typical system components required to model a full solar thermal system.  Models with varying degrees of complexity are included so that users can make a trade off between simulation speed and accuracy.

solartherm
    A Python library that provides common functions and classes for the other tools (e.g. st_simulate, st_optimise etc) to use.

st_simulate
    A Python script for simulating a system model.  It compiles the model, calls the simulation, and post processes the results.  It can also be used for performing parameter sweeps or just changing individual parameters without having to recompile the model each time.

st_optimise
    A Python script for model optimisation. See more details in the next section.
    
st_sensitivity
	A Python script that takes uncertain parameters in cost and performance, conducting Latin hypercube sampling (LHS) for sensitivity analysis on the techno-economic performance of a designed system. See more details in the next section.
	
st_contingency	
	A Python scripts that predicts contingency budget based on a re-optimal system design when cost and performance parameters are changed due to uncertain factors. See more details in the next section.

st_plotmat
    A Python script for easily plotting the results from a simulation.  Behind the scenes it uses the common `matplotlib <http://matplotlib.org>`_ library.

st_inspect
    A Python script for converting simulation results into CSV data. Results are output to the console (standard output) but can also be directed into a file (e.g. `st_inspect myfile.res > output.csv`)

st_wea_to_mo
    A Python script for converting TMY3 weather data into a format that is suitable for import into a simulation table.

st_get_aemo_prices
    A Python script that downloads spot market prices from `AEMO <http://aemo.com.au/>`_ for a particular year and region, and then converts them into a simulation-table-ready format.


The optimisation tool
^^^^^^^^^^^^^^^^^^^^^

Our optimisation tool (i.e. the ``st_optimise`` script) integrates with a range of optimisation algorithm packages, which is capable of handling a wide range of optimisation problems in concentrating solar thermal applications. An example of how to use this command-line tool is shown below::

    st optimise $mofn --method dakota_soga --objective lcoe --excel $excel_file --wd $working_dir --np 8

- ``$mofn`` is the directory of the SolarTherm model

- ``--method`` flag: this flag simply defines which optimisation method is going to be used. Options are:
	- ``dakota_soga`` : single objective genetic algorithm (SOGA) from `DAKOTA <https://dakota.sandia.gov/>`_
	- ``dakota_moga`` : multi-objective genetic algorithm (MOGA) from `DAKOTA <https://dakota.sandia.gov/>`_
	- ``pso`` : particle swarm optimisation (PSO) provided by `pyswarm <https://pyswarms.readthedocs.io/en/latest/>`_ package
	- ``cma`` : covariance matrix adaptation evolution strategy (CMA-ES) for non-linear numerical optimisation in Python `cma <https://pypi.org/project/cma/>`_ package
	- ``ga1`` : genetic algorithm (GA) provided by `pyevolve <http://pyevolve.sourceforge.net/>`_ package 
	- ``ga2`` : genetic algorimthm (GA) provided by `deap <https://deap.readthedocs.io/en/master/>`_ package
	- ``nsga2`` : non dominated sorting genetic algorithm (NSGA-II)provided by `deap <https://deap.readthedocs.io/en/master/>`_ package
	- ``COBYLA``, ``SLSQP``, ``TNC`` or ``L-BFGS-B`` provided by `scipy <https://scipy.org/>`_ package

	One can follow the following format to use this flag after the ``st_optimise`` command, for example::

    	--method dakota_soga

- ``--objective`` flag
	This flag is used to specify the objective function(s) that are going to be optimised. At the moment, these objectives can be the levelised cost of electricity/fuel (i.e. ``lcoe`` or ``lcof``),  the capacity factor(i.e. ``capf``), the annual electricity/fuel produced per year (``epy`` or ``fpy``) and/or the market spot revenue (``srev``). It is evident that the nature of some of these functions is for minimisation, while the others must be maximised in order to make logical sense. The default for the optimisation algorithm is minimising. A '-' sign needs to be given if the objective function is to be maximised. See an example shown below::

    	--objective lcoe,-epy
    
  Note that it is invalid to put the '-' sign directly after ``--objective``. At the moment, maximisation is only available in multi-objective optimisation. This will be refined in future work.
    
- ``--excel`` flag
	This flag specifies the directory of an excel spreadsheet that contains simulation parameters. There is an example spreadsheet provided in the ``examples`` folder in the SolarTherm package, which can be used as a template to fit into the ``st`` simulations. 


- ``--par`` flag
	Parameters can also be given by this flag, which takes the parameters with bounds and optional starting value in the form of NAME=LOW, HIGH [, START]
    
- ``--wd`` flag
	This flag specifies the working directory to save the simulation outputs

- ``--np`` flag
	This flag specifies the number of processors to run the simulations. For example ``--np 8`` for parallel multi-processing simulation with 8 processors.

- ``--restart`` flag
	This flag is given when you want to restart (continue) an optimisation at the point it was terminated (e.g. the optimisation has already been started but yet finished). This option is available only for the methods of ``dakota_soga`` and ``dakota_moga``.  

- ``--max_eval`` flag 
	This flag specifies the maximal number of evaluation when using ``dakota_soga`` or ``dakota_moga`` method

- ``--pop_size`` flag
	This flag specifies the population size when using ``dakota_soga`` or ``dakota_moga`` method

- ``--num_generations`` flag 
	This flag specifies the number of generations when using ``dakota_soga`` or ``dakota_moga`` method

- ``--seed`` flag
	This flag specifies the seed of data sampling when using ``dakota_soga`` or ``dakota_moga`` method

- ``--fuel`` flag 
	This flat is for those systems producing fuel rather than electricity. The ``-- fuel`` flag must be mentioned after the ``st_optimise`` command.

- ``--maxiter`` flag 
	This flag defines the maximum number of iterations (not necessarily number of simulations).  It should be noted that this flag is only for ``pso``, ``cma`` and SciPye optimisation methods.

- ``--dm`` flag
	This flag is used to specify the decision-making methods for ``nsga2``. The options are ``linmap`` or ``topsis``. In LINMAP method, a solution on the Pareto front curve with the minimum spacial distance from an ideal point (the point at which each single objective has its optimum value regardless of satisfaction of other objectives) is selected as the best optimum design point. In TOPSIS method, in addition to the ideal point, a non-ideal point (the point at which each objective has its worst value) is defined. In fact, the basic principle of this method is that the selected final optimal point must have the shortest distance from the ideal point and the farthest distance from the non-ideal point. Below shows the format this flag is used::

    	--dm linmap

- ``--outfile_p`` and ``-- outfig`` flags 
	These flags are used to save the optimal solutions and Pareto front graph from the nsga2 optimisation into files. The arguments given to these flags are the paths at which these files are going to be saved. For instance::

    	--outfile_p ../examples/result.txt
    
A full list of flags and instructions can be seen in the help manual by running the following command::
	
    	st optimise --help

    
The sensitivity and contingency analysis tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Our sensitivity and contingency analysis tools (i.e. the ``st_sensitivity`` and ``st_contingency`` script) coordinate uncertainties in system performance and cost parameters, provide information on likelihood of the techno-ecnomic performance of the simulated system model, and estimate contingency budget to mitigate risks. 


``st_sensitivity``
------------------

The ``st_sensitivity`` tool focuses on the effect of uncertain parameters on a fixed design. An example of how to use this command-line tool is shown below::	

    	st sensitivity $mofn --sample lhs --excel $excel_file  --ns 1000 --wd $working_dir --np 8 --runsolstice

- ``$mofn`` is the directory of the SolarTherm model

- ``--sample`` flag
	This flag is followed by the data sampling method. Options are ``lhs`` for Latin Hypercube sampling, and ``random`` for Monte-Carlo radom sampling

- ``--excel`` flag
	This flag is followed by the directory of an excel spreadsheet that contains simulation parameters. There is an example spreadsheet provided in the ``examples`` folder in the SolarTherm package, which can be used as a template to fit into the ``st`` simulations. 


- ``--ns`` flag
	This flag followed by the number of data samples
	
- ``--wd`` flag
	This flag is followed by the working directory to save the simulation outputs

- ``--np`` flag
	This flag is followed by the number of processors to run the simulations. The default (without giving this flag) is the maximal available processors on the machine. Set it to 1, the program will be run in a single processor mode.

- ``--runsolstice`` flag
	This flag needs to be given if optical simulations (using ``Solstice``) are involved in the system model. The program will be indicated to create different folders (i.e. ``optic_case_1``) to save the optical results for each data sample. 

A full list of flags and instructions can be seen in the help manual by running the following command::
	
    	st sensitivity --help
	

``st_contingency``
------------------

Uncertainties are commonly involved in a system design process. The optimal configuration of a system would be changed if some cost and performance parameters are deviated. The ``st_contingency`` tool re-optimises system design to cooperate with changes in performance parameters, assists sensitivity analysis and provides guidence on allocating contingency budgets to mitigate the risks. An example of how to use this command-line tool is shown below::

    		st contingency $mofn --excel $excel_file  --ns 1000 --wd $working_dir --np 8 --matfile_default_design $matfn --target_likelihood 0.9 --runsolstice --plot


- ``$mofn`` is the directory of the SolarTherm model


- ``--excel`` flag
	This flag is followed by the directory of an excel spreadsheet that contains simulation parameters. It is a compulsory input for the ``st_contingency`` tool, where all the design, performance and cost parameters are specified. There is an example spreadsheet provided in the ``examples`` folder in the SolarTherm package, which can be used as a template to fit into the ``st`` simulations. 

- ``--ns`` flag
	This flag followed by the number of data samples. The recommended number is greater than 1000. The data interpolation will be failed if too less number of data samples are created.
	
- ``--wd`` flag
	This flag is followed by the working directory to save the simulation outputs

- ``--np`` flag
	This flag is followed by the number of processors to run the simulations. The default (without giving this flag) is the maximal available processors on the machine. Set it to 1, the program will be run in a single processor mode.

- ``--matfile_default_design`` flag
	This flag is followd by the directory of the .mat result file of the default case (e.g. the optimal design at the default design condition). The default case is used as the base case to analyse risks and allocate contingency budget


- ``target_likelihood`` flag
	This flag is followed by the likelihood of LCOE that is of interests, e.g. if 0.9 is given then the P90 LCOE will be presented after the simulation. An althernative flag is ``target_lcoe``, which specifies the LCOE of interests and the program will return the likelihood to achieve this LCOE value and how much contingency budget is requried. These two flags cannot be given at the same time.


- ``--runsolstice`` flag
	This flag needs to be given if optical simulations (using ``Solstice``) are involved in the system model. The program will be indicated to create different folders (i.e. ``optic_case_1``) to save the optical results for each data sample. 
	
	
- ``--plot`` flag
	Plots of the distribution of the data samples, statistics of LCOE, energy production and capital costs will be created and shown if this flag is given.	


The ``st_contingency`` tool can also take data sample files directly as an input, and post process the data to provide contingency and statistic analysis. Just putting an additional flag to the command introduced above::

			--samplefile $samplefn  


A full list of flags and instructions can be seen in the help manual by running the following command::
	
    	st contingency --help



Common flags for all tools
--------------------------



  -h, --help            show this help message and exit
  -v                    verbose
  --start START         simulation start time: <number>[,y,d,m,s]
  --stop STOP           simulation stop time: <number>[,y,d,m,s]
  --step STEP           simulation time step: <number>[,y,d,m,s]
  --tolerance TOLERANCE
                        simulation tolerance: <number>
  --initStep INITSTEP   simulation initial step size used by dassl and ida
                        methods: <number>[,y,d,m,s]
  --maxStep MAXSTEP     simulation maximum absolute step size used by dassl
                        and ida methods: <number>[,y,d,m,s]
  --integOrder INTEGORDER
                        simulation maximum integration order used by dassl and
                        ida methods: <number>
  --solver SOLVER       solver choice for OpenModelica
  --nls NLS             non-linear solver choice for OpenModelica e.g. newton,
                        hybrid, kinsol, mixed, and homotopy
  --lv LV               a comma-separated String list specifing which logging
                        levels to enable, e.g. LOG_DASSL,LOG_SOLVER etc
  --fuel                run post-processing calculations for levelised cost of
                        fuel
  --np NP               number of processes (set to 0 or 1 for serial mode)
  --peaker              peaker configuration







  
    
