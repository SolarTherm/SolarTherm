#!/usr/bin/env python
##
# 
# Introduction
#---------------
# The input of DAKOTA is a file named sample.in
# There are six essential blocks in sample.in, namely
# 1) envrionment
# 2) model
# 3) interface
# 4) responses
# 5) method
# 6) variables
# Details are available in the DAKOTA User Manual: 
# https://dakota.sandia.gov/sites/default/files/docs/6.14/Users-6.14.0.pdf
# In our application, the environment (1) and model (2) are fixed as a general form;
# The interface (3) is an external python function that interacts with SolarTherm;
# This is a wrapper to define (4) to (6) for a specific applicatoin,
# e.g. optimisation, uncertainty quantification or contingency analysis.
#
# Capability of the integration with DAKOTA inlucdes: 
# I.   Parametric study, e.g. uniform, LHS etc
# II.  Uncertainty study, e.g. Monte-Carlo, LHS etc
# III. Optimisation, e.g. 
#     	(1) gradient-based 
#     	(2) non-gradient-based
#     	(3) derivative-free
#     	(4) surrogate-based
# IV. Contingency analysis
#
# with multiprocessing options
# I.   Single-level parallelism, e.g. 
#		(1) asychronous local parallelism
#		(2) message passing parallelism
#   	(3) hybrid parallelisim
# II.  Multi-level parallelism, e.g.
#		(1) asychronous local parallelism
#		(2) message passing parallelism
#   	(3) hybrid parallelisim
## TODO 
# Parametric study is not implemented, but it is not a priority
# More algorithms for optimisaiton, the currently available are soga, moga  
# More complex parallelism is to be developed (tested), e.g. hybrid parallelisim


import os

class DakotaSampleIn:
	'''
	This class contains six sections that are corresponding to the six blocks for DAKOTA inputs 

		Arguments:
		* `casedir` (str): directory to save the sample.in file	

		* `fn` (str): the full path of the openmodelica (SolarTherm) model
		* `system` (str): 'ELECTRICITY' or 'FUEL' or 'TEST'
		* `method` (str): name of the method
				'uq': uncertainty quantification
				'soga': single objective genetic algorithm for optimisation
				'moga': multi-objective genetic algorithm for optimisation
				'moga-hybrid': a combination of moga and random sampling 
					approach for contingency analysis	

		* `start` (str): simulation start time: <number>[,y,d,m,s]
		* `stop` (str): simulation stop time: <number>[,y,d,m,s] 
		* `step` (str): simulation time step: <number>[,y,d,m,s]
		* `initStep (str): simulation initial step size used by dassl and ida methods: <number>[,y,d,m,s]
		* `maxStep` (str): simulation maximum absolute step size used by dassl and ida methods: <number>[,y,d,m,s]
		* `integOrder` (str): 	simulation maximum integration order used by dassl and ida methods: <number>
		* `tolerance` (str): simulation tolerance		
		* `solver` (str): solver choice for OpenModelica
		* `nls` (str): non-linear solver choice for OpenModelica e.g. newton, hybrid, kinsol, mixed, and homotopy
		* `lv` (str): a comma-separated String list specifing which logging levels to enable, e.g. LOG_DASSL,LOG_SOLVER etc
		* `runsolstice` (bool): the model runs Solstice optical simulations or not
		* `peaker` (bool): the model evaluate lcoe_peaker (for peaker plant) or not	
		* `res_names (list): a list of strings that define the names of variables/results of interests 
		* `signs` (list): a list of 1 or -1 that identifies the corresponding 'res_name' to be minimised (1) or maximsed (-1)
		
		'''
						
	def __init__(self, casedir, fn, system, method, args, var_names, nominals=None, lbs=None, ubs=None, stdevs=None, dists=None, optimisation=False, start='0', stop='86400', step='5m', initStep=None, maxStep=None, integOrder='5', tolerance='1e-04', solver='dassl', nls='homotopy', lv='-LOG_SUCCESS,-stdout', runsolstice=0, peaker=0, res_names=["lcoe"], signs=[1]):
		dktin='''
		# Dakota Input File: sample.in
		# Usage:
		#    dakota -i sample.in -o sample.out > sample.stdout
		# or if run in multi-level parallelism:
		#    mpirun dakota -i sample.in -o sample.out > sample.stdout
		#    or
		#	 mpexec dakota -i sample.in -o sample.out > sample.stdout
					
		'''
		self.casedir=os.path.abspath(casedir)
		if not os.path.exists(self.casedir):
			os.makedirs(self.casedir)

		self.fn=os.path.abspath(fn)
		self.system=system
		self.start=start
		self.stop=stop
		self.step=step
		self.initStep=initStep
		self.maxStep=maxStep
		self.integOrder=integOrder
		self.tolerance=tolerance
		self.solver=solver
		self.nls=nls
		self.lv=lv
		self.runsolstice=runsolstice
		self.peaker=peaker
		self.res_names=res_names
		self.signs=signs
		
		self.method=method
		self.set_omsim()
		dktin+=self.dakota_environment()
		dktin+=self.dakota_model()
		dktin+=self.dakota_interface()
		dktin+=self.dakota_responses()
		dktin+=self.dakota_method(args)
		dktin+=self.dakota_variables(var_names, nominals, lbs, ubs, stdevs, dists)
		
		with open(self.casedir+'/sample.in', 'w') as f:
			f.write(dktin)		
			
		gen_interface_bb(self.casedir)
				
	def dakota_environment(self):
		dktin='''
		environment
			tabular_data
			tabular_data_file = "sample.dat"
					
		'''
		return dktin
	
	def dakota_model(self):
		dktin='''
		model
			single
					
		'''
		return dktin

	def dakota_interface(self):

		dktin='''
		interface
			fork
			analysis_drivers = "%s/interface_bb.py"
			parameters_file = "params.in"
			results_file = "results.out"
			file_tag 
			#file_save 	
					
		'''%self.casedir
		return dktin	
	
	
	def dakota_responses(self):
	
		num_res=len(self.res_names)
		if self.method=='uq' or self.method=='moga-hybrid':
			optimisation=False
		else:
			optimisation=True

		if optimisation:
			dktin='''
		responses
			objective_functions = %s
			no_gradients
			no_hessians	
				
		'''%num_res		
		
		else:
			dktin='''
		responses
			response_functions = %s
			no_gradients
			no_hessians		
			
		'''%num_res
			
		return dktin	


	def dakota_method(self, args={}):
		'''
		Arguments:
		args (dict): arguments for the corresponding method
		'''
		mthd=DakotaMethod()
		
		if self.method=='uq':
			if 'sample_type' in args:
				sample_type=args['sample_type']
			else:
				sample_type='lhs'	
			
			if 'num_sample' in args:
				num_sample=args['num_sample']
			else:
				num_sample=10
				
			m=mthd.uqsample(sample_type, num_sample)
			
		elif self.method=='soga':
		
			if 'max_eval' in args:
				max_eval=args['max_eval']
			else:
				max_eval=2000
				
			if 'pop_size' in args:
				pop_size=args['pop_size']
			else:
				pop_size=48
			
			if 'num_generations' in args:
				num_generations=args['num_generations']
			else:
				num_generations=40
				
			if 'seed' in args:
				seed=args['seed']
			else:
				seed=10983
									
			m=mthd.soga(max_eval=max_eval, pop_size=pop_size, num_generations = num_generations, seed=seed)			
				
		elif self.method =='moga':
		
			if 'max_eval' in args:
				max_eval=args['max_eval']
			else:
				max_eval=2000
				
			if 'pop_size' in args:
				pop_size=args['pop_size']
			else:
				pop_size=48
			
			if 'num_generations' in args:
				num_generations=args['num_generations']
			else:
				num_generations=40
				
			if 'seed' in args:
				seed=args['seed']
			else:
				seed=10983

			if 'final_solutions' in args:
				final_solutions=args['final_solutions']
			else:
				final_solutions=3
													
			m=mthd.moga(final_solutions=final_solutions, max_eval=max_eval, pop_size=pop_size, num_generations = num_generations, seed=seed)		
			
				
		elif self.method =='moga-hybrid':
			pass
		
		dktin='''
		method
		%s			
		'''%m
		
		return dktin				
		
	def dakota_variables(self, var_names, nominals=None, lbs=None, ubs=None, stdevs=None, dists=None):
		'''
		Arguments:
	
		* `var_names` (list): a list of strings about the variable names
				 it is a nested list if the dists are not 1
		* `nominals` (list or None): a list of nominal values of the variables (could be nested)
				 it is None if a uniform distribution is specified
		* `lbs` (list or None): a list of lower bounds of the variables (could be nested)
				 it is None if a normal distribution is specified		
		* `ubs` (list or None): a list of upper bounds of the variables (could be nested)
				 it is None if a normal distribution is specified		
		* `stdevs` (list or None): a list of standard deviations of the variables 
				 it is None if it is not a Normal distribution			
		* `dists` (list or None): a list of distributions of the variables  
				 it is for specifying different distributions for different variables
				 the options are 'uniform', 'normal', 'pert'
				 it is None if the method is not 'uq' or 'moga-hybrid'
		'''
	
		dktvar=DakotaVariables()		
		if self.method=='uq':
			if type(dists) is list:
				m=''
				num=len(dists)
				
				for i in range(num):
					dist=dists[i]
					if dist=='uniform':
						if num==1:
							name=var_names
							lb=lbs
							ub=ubs
						else:
							name=var_names[i]
							lb=lbs[i]
							ub=ubs[i]							
						m+=dktvar.uniform_sample(var_names=name, lbs=lb, ubs=ub)
						
					elif dist=='normal':
						if num==1:
							name=var_names
							nominal=nominals
							stdev=stdevs
						else:
							name=var_names[i]
							nominal=nominals[i]
							stdev=stdevs[i]						
						m+=dktvar.normal_sample(var_names=name, nominals=nominal, stdevs=stdev)					
					elif dist=='pert':	
						if num==1:
							name=var_names
							nominal=nominals							
							lb=lbs
							ub=ubs
						else:
							name=var_names[i]
							nominal=nominals[i]
							lb=lbs[i]
							ub=ubs[i]							
						m+=dktvar.pert_sample(var_names=name, nominals=nominal, lbs=lb, ubs=ub)			
						
			else:
				raise Exception("'dists' must be a list for uncertainty samples ")					
		
		elif self.method=='moga-hybrid':
			pass
		
		else: #optimisations
			m=dktvar.continuous_design(var_names, nominals, lbs, ubs)

		dktin='''
		variables
		%s
		%s
		'''%(self.omsim, m)	
		return dktin
	
	def set_omsim(self):
	
		if len(self.res_names)!=len(self.signs):
			raise Exception("The number of signs and objectives are not equal")	
		num_res=len(self.res_names)
						
		n=["fn", "system", "start", "stop", "step", "initStep", "maxStep",  "integOrder", "tolerance", "solver", "nls" ,"lv" , "runsolstice", "peaker", "num_res"]
		v=[self.fn, self.system, self.start, self.stop, self.step, self.initStep, self.maxStep, self.integOrder, self.tolerance, self.solver, self.nls, self.lv, self.runsolstice, self.peaker, num_res]
		
		for i in range(num_res):
			n.append('res_%s'%(i+1))
			v.append(self.res_names[i])
		for i in range(num_res):
			n.append('sign_%s'%(i+1))
			v.append(self.signs[i])			

		num=len(n)	
		self.omsim=''
		self.omsim+='    discrete_state_set\n'
		self.omsim+='        		string %s\n'%num			
		self.omsim+='        		set_values'	
		
		for i in range(num):
			self.omsim+=' "%s"'%v[i]
		self.omsim+='\n'    
		self.omsim+='        		descriptors'			
		for i in range(num):
		    self.omsim+=' "%s"'%n[i]
		self.omsim+='\n'    
			
			

class DakotaMethod(DakotaSampleIn):
	def __init__(self):
		'''
		The 'method' block in DAKOTA
		
		-- uqsample is for uncertainty quantification, including LHS or MC random sample
		-- moga is multi-objective genetic algorithm
		-- soga is single-objective genetic algorithm
		-- moga-hybrid: a combination of moga and random sampling approach for contingency analysis		
		There are more available from DAKOTA but not yet implemented.
		'''	
		pass

	def uqsample(self, sample_type='lhs', num_sample=10):
		'''
		This is method calls uncertainty quantification (UQ) sampling in DAKOTA
		
		Arguments:
		* `sample_type` (str): 'lhs' (i.e. Latin hyper-cube sample) 
				     or 'random'(i.e. Monte-Carlo sample)	 
		* `num_sample` (int): number of samples	
		
		Return:
		* `m` (str): the method specificaition for DAKOTA			
		'''
		
		m=''
		m+='    sampling\n'
		m+='        		sample_type %s\n'%sample_type		
		m+='        		samples = %s\n'%num_sample
		return m
	
	def moga(self,seed=10983, max_eval=2500, init_type='unique_random', pop_size=48, crossover_type='shuffle_random', num_offspring=2, num_parents=2, crossover_rate=0.8, mutation_type='replace_uniform', mutation_rate=0.1, fitness_type='domination_count', percent_change = 0.05, num_generations = 40, final_solutions = 3):

		'''
		This is method calls moga (multi-objective genetic algorithm) in DAKOTA for optimisation
		
		Arguments:
		* `seed` (int): index of seed, to generate repeatable results
		* `max_eval` (int): the maximal nubmer of function evaluations	
		* `init_type` (str): initialisation type, 'unique_random', 'simple_random', or 'flat_file'
		* `pop_size` (int): number of populations for each generation	
		* `crossover_type` (str): 'shuffle_random', 'multi_point_parameterized_binary' etc
		* `num_offspring` (int): number of off spring
		* `num_parents` (int): number of parents
		* `corssover_rate` (float): cross over rate
		* `mutation_type` (str): mutation tpye
		* `mutation rate` (float): mutation rate
		* `fitness_type` (str): fitness type
		* `percent_change` (float): percent change
		* `num_generations` (int): the maximal number of generations
		* `final_solutions` (int): the number of first best solutions
		
		Return:
		* `m` (str): the method specificaition for DAKOTA	
		'''

		m=''
		m+='    moga\n'
		m+='        		seed = %s\n'%seed	
		m+='    		max_function_evaluations = %s\n'%max_eval
		m+='    		initialization_type %s\n'%init_type
		m+='	    		population_size=%s\n'%pop_size  		
		m+='    		crossover_type %s\n'%crossover_type
		m+='        		num_offspring = %s num_parents = %s\n'%(num_offspring, num_parents)
		m+='        		crossover_rate = %s\n'%crossover_rate
		m+='    		mutation_type %s\n'%mutation_type
		m+='        		mutation_rate = %s\n'%mutation_rate
		m+='    		fitness_type %s\n'%fitness_type
		m+='    		replacement_type below_limit = 6\n'
		m+='        		shrinkage_fraction = 0.9\n'
		m+='    		convergence_type metric_tracker\n'
		m+='        		percent_change = %s num_generations = %s\n'%(percent_change, num_generations)
		m+='    		final_solutions = %s\n'%final_solutions
		m+='    		output silent\n'		
		return m


	def soga(self,seed=10983, max_eval=2000, init_type='unique_random', pop_size=48, crossover_type=None,  num_offspring=2, num_parents=2, crossover_multip=2, crossover_rate=0.8, mutation_type='replace_uniform', mutation_rate=0.2, fitness_type='merit_function', percent_change = 0.05, num_generations = 20):

		'''
		This is method calls soga (single-objective genetic algorithm) in DAKOTA for optimisation
		
		Arguments:
		* `seed` (int): index of seed, to generate repeatable results
		* `max_eval` (int): the maximal nubmer of function evaluations	
		* `init_type` (str): initialisation type, 'unique_random', 'simple_random', or 'flat_file'
		* `pop_size` (int): number of populations for each generation			
		* `crossover_type` (str): 'shuffle_random', 'multi_point_parameterized_binary' etc
		* `num_offspring` (int): number of off spring
		* `num_parents` (int): number of parents
		* `corssover_multip` (float): cross over multiple		
		* `corssover_rate` (float): cross over rate
		* `mutation_type` (str): mutation tpye
		* `mutation rate` (float): mutation rate
		* `fitness_type` (str): fitness type
		* `percent_change` (float): percent change
		* `num_generations` (int): the maximal number of generations
		
		Return:
		* `m` (str): the method specificaition for DAKOTA	
		'''	

		m=''
		m+='    soga\n'
		m+='        		seed = %s\n'%seed	
		m+='    		max_function_evaluations = %s\n'%max_eval
		m+='    		initialization_type %s\n'%init_type
		m+='	    		population_size=%s\n'%pop_size 
		if crossover_type==None:
			m+='    		crossover_type\n'
			m+='        		multi_point_parameterized_binary= %s\n'%crossover_multip
			m+='        		crossover_rate = %s\n'%crossover_rate		
		else: 
			m+='    		crossover_type %s\n'%crossover_type
			m+='        		num_offspring = %s num_parents = %s\n'%(num_offspring, num_parents)
			m+='       		crossover_rate = %s\n'%crossover_rate
		m+='    		mutation_type %s\n'%mutation_type
		m+='        		mutation_rate = %s\n'%mutation_rate
		m+='    		fitness_type %s\n'%fitness_type
		m+='    		replacement_type elitist\n'
		m+='    		convergence_type average_fitness_tracker\n'
		m+='        		percent_change = %s num_generations = %s\n'%(percent_change, num_generations)
		m+='    		output silent\n'		
		return m

	

class DakotaVariables(DakotaSampleIn):
	def __init__(self):
		'''
		The 'variables' block in DAKOTA
		'''	
		pass
	

	def uniform_sample(self, var_names, lbs, ubs):
		'''
		Set variables as uniform distribution

		Arguments:
		* `var_names` (list): a list of string, the names of the varaibles
		* `lbs` (list): a list of float, the lower bound of each variable
		* `ubs` (list): a list of float, the upper bound of each variable

		Return:
		* `m` (str): the variable sampling specificaition for DAKOTA	
		'''	
		var_num=len(var_names)			
		m=''		
		m+='    uniform_uncertain=%s\n'%var_num
		m+='        		lower_bounds'		
		for i in range(var_num):
		    m+=' %s'%lbs[i]
		m+='\n'    
		m+='        		upper_bounds'	
		for i in range(var_num):
		    m+=' %s'%ubs[i]
		m+='\n' 
		m+='        		descriptors'	
		for i in range(var_num):
		    m+=' "%s"'%var_names[i]
		m+='\n' 		
						
		return m

	def normal_sample(self, var_names, nominals, stdevs):
		'''
		Set variables as Normal distribution

		Arguments:
		* `var_names` (list): a list of string, the names of the varaibles
		* `nominals` (list): a list of float, the nominal (mean) value of each variable 
		* `stdevs` (list): a list of float, the standard deviation of each variable

		Return:
		* `m` (str): the variable sampling specificaition for DAKOTA
		'''	
				
		var_num=len(var_names)			
		m=''		
		m+='    normal_uncertain=%s\n'%var_num
		m+='        		means'		
		for i in range(var_num):
		    m+=' %s'%nominals[i]
		m+='\n'    
		m+='        		std_deviations'	
		for i in range(var_num):
		    m+=' %s'%stdevs[i]
		m+='\n' 
		m+='        		descriptors'	
		for i in range(var_num):
		    m+=' "%s"'%var_names[i]
		m+='\n' 		
						
		return m
		

	def pert_sample(self, var_names, nominals, lbs, ubs, scale=4.):
		'''
		Set variables as Pert-beta distribution
		
		We would like to have a data sample that is Pert distribution, 
		but the Pert distribution is not directly avaiable in DAKOTA
		The closest available is the Beta distribution
		This functions takes the inputs for pert distributions, 
		convert them to the corresponding Beta distribution
		and then return the sampling specification for DAKOTA

		Arguments:
		* `var_names` (list): a list of string, the names of the varaibles
		* `nominals` (list): a list of float, the nominal(mean) value of each variable 
		* `lbs` (list): a list of float, the lower bound of each variable
		* `ubs` (list): a list of float, the upper bound of each variable
		* `scale` (float): the scale of the nominal value for pert distribution, defaul is 4 
		
		Return:
		* `m` (str): the variable sampling specificaition for DAKOTA				
		'''	
		#FIXME there are some cases (alpha and beta values) 
		# that the DAKOTA package cannot sample	
		# not clear about the reason yet
		# need to investigate
			
		var_num=len(var_names)
		
		# convert pert to beta distribution		
		alphas=[]
		betas=[]
		for i in range(var_num):
			xmax=ubs[i]
			xmin=lbs[i]
			x=nominals[i]
			mean=(xmin+xmax+scale*x)/(scale+2)
			
			if abs(mean-x)<1e-10:
				a=scale/2.+1.
			else:
				a=(mean-xmin)*(2.*x-xmin-xmax)/(x-mean)/(xmax-xmin)
				
			b=a*(xmax-mean)/(mean-xmin)
			alphas.append(a)
			betas.append(b)
			
		m=''		
		m+='    beta_uncertain=%s\n'%var_num
		m+='        		alphas'		
		for i in range(var_num):
		    m+=' %s'%alphas[i]
		m+='\n'    
		m+='        		betas'	
		for i in range(var_num):
		    m+=' %s'%betas[i]
		m+='\n' 
		m+='        		lower_bounds'	
		for i in range(var_num):
		    m+=' %s'%lbs[i]
		m+='\n' 
		m+='        		upper_bounds'	
		for i in range(var_num):
		    m+=' %s'%ubs[i]
		m+='\n' 				
		m+='        		descriptors'	
		for i in range(var_num):
		    m+=' "%s"'%var_names[i]
		m+='\n' 		
						
		return m
		

	def beta_dist(self, a, b, lb, ub, x):
		'''
		This function calculate a Beta distribution
		Reference: DAKOTA Reference-6.10.0.pdf page3250 

		Arguments:
		* `a`  (float): the alpha constant
		* `b`  (float): the beta constant
		* `lb` (float): lower bound
		* `ub` (float): upper bound
		* `x`  (float): the nominal value
		
		Return:
		* `f` (float): the Beta distribution	
		'''
		from scipy.special import gamma
		B=gamma(a)*gamma(b)/gamma(a+b)
		f=(x-lb)**(a-1.)*(ub-x)**(b-1.)/B/(ub-lb)**(a+b-1)
		return f


	def continuous_design(self, var_names, nominals, lbs, ubs):
		'''
		Set variables as for continuous design (optimisation)
		
		Arguments:
		* `var_names` (list): a list of string, the names of the varaibles
		* `nominals` (list): a list of float, the nominal(mean) value of each variable 
		* `lbs` (list): a list of float, the lower bound of each variable
		* `ubs` (list): a list of float, the upper bound of each variable
		
		Return:
		* `m` (str): the variable sampling specificaition for DAKOTA				
		'''	
		
		var_num=len(var_names)			
		m=''		
		m+='    continuous_design=%s\n'%var_num
		m+='        		initial_point'		
		for i in range(var_num):
		    m+=' %s'%nominals[i]
		m+='\n'    
		m+='        		lower_bounds'	
		for i in range(var_num):
		    m+=' %s'%lbs[i]
		m+='\n' 
		m+='        		upper_bounds'	
		for i in range(var_num):
		    m+=' %s'%ubs[i]
		m+='\n' 		
		m+='        		descriptors'	
		for i in range(var_num):
		    m+=' "%s"'%var_names[i]
		m+='\n' 						
		return m

	

def gen_interface_bb(savedir):
	'''
	This function generate the interface_bb.py script 
	which will be excuted by DAKOTA

	* `savedir` (str): directory to save the interface_bb.py file	
	* `perf_n` (list of str): a list of the names of the resulting performance, e.g. lcoe, capf, epy, srev	
	* `perf_sign` (list of float): a list of signs for the optimisation, e.g. 1 is to minimise, -1 is to maximise; 
								   perf_sign=None if it is a study other than optiisation		
	'''
	

	bb='''#!/usr/bin/env python

# Dakota will execute this script
# The command line arguments will be extracted by dakota.interfacing automatically.

# load the necessary Python modeuls
import dakota.interfacing as di
import os
import glob

# Parse Dakota parameters file
params, results = di.read_parameters_file()

# obtain the modelica file name
# variable names and values
# index of the case (suffix for output)
names=params.descriptors

fn=params.__getitem__("fn") #the modelica file
system=params.__getitem__("system") # fuel system or power system
start=str(params.__getitem__("start")) 
stop=str(params.__getitem__("stop")) 
step=str(params.__getitem__("step"))
initStep=params.__getitem__("initStep")
maxStep=params.__getitem__("maxStep") 
integOrder=str(params.__getitem__("integOrder"))
tolerance=str(params.__getitem__("tolerance"))
solver=str(params.__getitem__("solver"))
nls=str(params.__getitem__("nls"))
lv=str(params.__getitem__("lv"))
runsolstice=float(params.__getitem__("runsolstice"))
peaker=float(params.__getitem__("peaker"))
num_res=int(params.__getitem__("num_res"))

initStep = None if initStep == 'None' else str(initStep)
maxStep = None if maxStep == 'None' else str(maxStep)
model=os.path.splitext(os.path.split(fn)[1])[0] # model name

var_n=[] # variable names
var_v=[] # variable values
print('')
print(names[:-(15+2*num_res)])
for n in names[:-(15+2*num_res)]:
	#var_n.append(n.encode("UTF-8"))
	var_n.append(str(n))
	var_v.append(str(params.__getitem__(n)))
	print('variable   : ', n, '=', params.__getitem__(n))

# case suffix
suffix=results.results_file.split(".")[-1]

if runsolstice:
	optic_folder='optic_case_%s'%suffix
	var_n.append('casefolder')
	var_v.append(optic_folder)
	print('casefolder = '+ optic_folder)

# run solartherm
from solartherm import postproc
from solartherm import simulation
sim = simulation.Simulator(fn=fn, suffix=suffix, fusemount=False)
if not os.path.exists(model):
	sim.compile_model()
	sim.compile_sim(args=['-s'])

sim.update_pars(var_n, var_v)
sim.simulate(start=start, stop=stop, step=step, initStep=initStep, maxStep=maxStep, integOrder=integOrder, solver=solver, nls=nls, lv=lv)

try:

	import DyMat
	res_fn=DyMat.DyMatFile(sim.res_fn)
	
	if system=='FUEL':
		resultclass = postproc.SimResultFuel(sim.res_fn)
	else:
		resultclass = postproc.SimResultElec(sim.res_fn)
	if peaker:
		perf = resultclass.calc_perf(perker=bool(peaker))
	else:	
		perf = resultclass.calc_perf()
		
	summary=resultclass.report_summary(var_n=var_n, savedir='.', suffix=suffix)

	solartherm_res=[]
	for i in range(num_res):
		sign=float(params.__getitem__("sign_%s"%(i+1)))
		name=params.__getitem__("res_%s"%(i+1))
		if name=='epy':
			res=sign*perf[0]
		elif name=='lcoe':
			res=sign*perf[1]
		elif name=='capf':
			res=sign*perf[2]
		elif name=='srev':
			res=sign*perf[3]
		else:
			res=sign*res_fn.data(name)[0]					
		solartherm_res.append(res)
		print('objective %s: '%i, name, res)
		
except:
	solartherm_res=[]
	for i in range(num_res):	
		sign=float(params.__getitem__("sign_%s"%(i+1)))
		if sign>0: #minimisation
			error=99999
		else: # maxmisation
			error=0 
		solartherm_res.append(sign*error)
	print('Simulation Failed')


print('')
# Return the results to Dakota
for i, r in enumerate(results.responses()):
    if r.asv.function:
        r.function = solartherm_res[i]
results.write()

map(os.unlink, glob.glob(sim.res_fn))
map(os.unlink, glob.glob(model+'_init_%s.xml'%suffix))

'''
	if not os.path.exists(savedir):
		os.makedirs(savedir)
	with open(savedir+'/interface_bb.py', 'w') as f:
		f.write(bb)



if __name__=='__main__':
	casedir='test-dakota'
	fn='../../../examples/SimpleSystem.mo'
	system='ELECTRICITY'
		
	method='soga' # soga, moga, uq, moga-hybrid
	
	args={}	 
	var_names=['t_storage']	
	nominals=[12]
	lbs=[5]
	ubs=[15]	
	dists=None	
	stdevs=None
	if method=='soga':
		args['max_eval']=999
		args['pop_size']=999
		args['num_generations']=99
		num_res=1
		optimisation=True

	elif method == 'moga':
		args['max_eval']=999
		args['pop_size']=999
		args['num_generations']=99
		args['final_solutions']=9
		num_res=2
		optimisation=True
	
	elif method == 'uq':
		dists=['uniform'] # uniform, normal, pert
		args['sample_type']='random'
		args['num_sample']=9999	
		num_res=1
		optimisation=False
		if 'normal' in dists:
			stdevs=[1]

				
	dkt=DakotaSampleIn(casedir, fn, system, method, args, var_names, nominals, lbs, ubs, stdevs, dists, optimisation, start='0', stop='1y', step='5m', initStep=None, maxStep=None, integOrder='5', tolerance='1e-04', solver='dassl', nls='homotopy', lv='-LOG_SUCCESS,-stdout', runsolstice=0, peaker=0, res_names=["lcoe"], signs=[1])

