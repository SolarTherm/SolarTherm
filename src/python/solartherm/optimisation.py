import time
import numpy as np


def st_pso(objfunc, par_b, maxiter, scale, offset):
	'''
	pso optimisation
	'''
	try:
		from pyswarm import pso
	except ImportError:
		pso = None
	assert pso is not None, 'Library for pso is not installed'

	swarmsize=5
	lb = [v[0] for v in par_b]
	ub = [v[1] for v in par_b]
	res = pso(objfunc, lb, ub, maxiter=maxiter, swarmsize=swarmsize)
	cand = [scale[i]*v + offset[i] for i, v in enumerate(res[0])]

	return res[1], cand


def st_cma(objfunc, par_b, par_0, maxiter, scale, offset):
	try:
		import cma
	except ImportError:
		cma = None
	assert cma is not None, 'Library for cma is not installed'

	sigma0 = 0.2 # "step size", should be around 1/4 of search domain
	popsize = 5
	lb = [v[0] for v in par_b]
	ub = [v[1] for v in par_b]
	res = cma.fmin(objfunc, par_0, sigma0,
			restarts=0,
			options={
					'bounds': [lb, ub],
					#'maxfevals': args.maxiter,
					'maxiter': maxiter,
					'popsize': popsize,
			})
	cand = [scale[i]*v + offset[i] for i, v in enumerate(res[0])]

	return res[1], cand


def st_ga1(objfunc, par_b, par_n, scale, offset):

	import pylab as pl
	try:
		import pyevolve as pe
		from pyevolve import GSimpleGA, G1DList, Initializators, Crossovers, Selectors, Mutators, Scaling, Consts
	except ImportError:
		pe = None
	assert pe is not None, 'Library for pyevolve is not installed'

	lb = [v[0] for v in par_b] # Normalised lower bound
	ub = [v[1] for v in par_b] # Normalised upper bound

	ind_size = len(par_n) # Number of design parameters
	pop_size = 100 # Set number of individuals in population
	ngen = 2 # Total number of generation to run
	cxpb = 0.98 # Crossover probability
	mutpb = 0.01 # Mutation probability
	freq_stats = 10 # Frequency of stats
	paral_eval = False # To enable parallel evaluation. Only use it when the fitness function is slow!

	pl.ion()

	genome = G1DList.G1DList(ind_size) # Genome instance
	genome.setParams(rangemin = lb[0], rangemax = ub[0]) # Set the range min and max of the 1D List
	genome.evaluator.set(objfunc) # The evaluator function (fitness/objective function)	
	genome.initializator.set(Initializators.G1DListInitializatorReal) # Real initialization function of G1DList
	genome.crossover.set(Crossovers.G1DListCrossoverUniform) # The G1DList Uniform Crossover
	genome.mutator.set(Mutators.G1DListMutatorRealRange) # Simple real range mutator for G1DList

	ga = GSimpleGA.GSimpleGA(genome) # Genetic algorithm instance
	ga.selector.set(Selectors.GTournamentSelector) # Set the selector method
	ga.setMinimax(Consts.minimaxType["minimize"])
	#if framework == 'soo_min':
	#	ga.setMinimax(Consts.minimaxType["minimize"])
	#else:
	#	ga.setMinimax(Consts.minimaxType["maximize"])
	ga.setPopulationSize(pop_size) # Set the population size for each generation
	ga.setGenerations(ngen) # Set the number of generation
	ga.setCrossoverRate(cxpb) # Set the crossover rate  
	ga.setMutationRate(mutpb) # Set the mutation rate
	ga.terminationCriteria.set(GSimpleGA.ConvergenceCriteria) # Terminate the evolution when the population have converged
	pop = ga.getPopulation() # Return the internal population of GA Engine
	pop.scaleMethod.set(Scaling.SigmaTruncScaling) # Sigma Truncation scaling scheme, allows negative scores
	ga.evolve(freq_stats=freq_stats) # Run the optimisation and print the stats of the ga every n generation
	ga.setMultiProcessing(flag=paral_eval, full_copy=False) # Set the flag to enable/disable the use of python multiprocessing module

	res = ga.bestIndividual() # Best individual in normalised form
	cand = [scale[i]*v + offset[i] for i, v in enumerate(res.genomeList)] # Denormalised best individual


	return res.score, cand


def st_ga2(objfunc, par_b, par_n, scale, offset):

	try:
		import random
		import deap
		from deap import algorithms, base, creator, tools
	except ImportError:
		deap = None
	assert deap is not None, 'Library for deap is not installed'

	lb = [v[0] for v in par_b] # Normalised lower bound
	ub = [v[1] for v in par_b] # Normalised upper bound

	ind_size = len(par_n) # Number of design parameters
	pop_size = 100 # Set number of individuals in population
	ngen = 2 # Total number of generation to run
	cxpb = 0.98 # Crossover probability
	cxpb_in = 0.5 # Probability of crossover within individual
	mutpb = 0.02 # Mutation probability
	mutpb_in = 0.01 # Probability of mutation within individual
	paral_eval = False # To enable parallel evaluation. Only use it when the fitness function is slow!
	n_cores = 4 # Number of cores for parallel evaluation of the fitness function

	creator.create("FitnessMin", base.Fitness, weights=(-1.0,))

	#if framework == 'soo_min':
	#	creator.create("FitnessMin", base.Fitness, weights=(-1.0,))
	#else:
	#	creator.create("FitnessMin", base.Fitness, weights=(1.0,))

	creator.create("Individual", list, fitness=creator.FitnessMin)

	toolbox = base.Toolbox() # Attribute generator
	toolbox.register("attr_float", random.uniform, lb[0], ub[0]) # Generate a vector of uniform random numbers within the lower and upper bounds of the design variables
	toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_float, ind_size) # Structure initializer for individuals
	toolbox.register("population", tools.initRepeat, list, toolbox.individual) # Structure initializer for the population

	# Decorator to obtain a constrained domain that is applied to the mutation and crossover
	#def checkBounds(min, max):
		#def decorator(func):
			#def wrappper(*args, **kargs):
				#offspring = func(*args, **kargs)
				#for child in offspring:
					#for i in range(len(child)):
						#if child[i] > max:
							#child[i] = max
						#elif child[i] < min:
							#child[i] = min
				#return offspring
			#return wrappper
		#return decorator

	# NOTE: For penalty function-based constraint handling see: http://deap.readthedocs.io/en/master/tutorials/advanced/constraints.html

	# Register the GA operators
	toolbox.register("evaluate", objfunc) # Set the evaluation function
	toolbox.register("mate", tools.cxUniform, indpb=cxpb_in) # Set the crossover type
	toolbox.register("mutate", tools.mutFlipBit, indpb=mutpb_in) # Set the mutation type
	#toolbox.register("select", tools.selNSGA2) # Set the selector method
	toolbox.register("select", tools.selTournament, tournsize=3) # Set the selector method

	#toolbox.decorate("mate", checkBounds(lb[0], ub[0])) # Check bounds for a constrained domain
	#toolbox.decorate("mutate", checkBounds(lb[0], ub[0])) # Check bounds for a constrained domain

	# Parallel evaluation by running the computation multicore
	if paral_eval:
		#pool = multiprocessing.Pool(processes=n_cores)
		#toolbox.register("map", pool.map) # Change the map functions everywhere to toolbox.map to make the algorithm use a multicored map
		toolbox.register("map", futures.map) # Change the map functions everywhere to toolbox.map to make the algorithm use a multicored map

	pop = toolbox.population(n=pop_size) # Set the size of population (individuals)

	fitnesses = list(toolbox.map(toolbox.evaluate, pop)) # Evaluate the entire population

	for ind, fit in zip(pop, fitnesses):
		ind.fitness.values = fit  # Run the fitness (min mean on each of the individuals)

	fits = [ind.fitness.values[0] for ind in pop] # # Gather all the fitnesses in one list

	# Begin the evolution
	for g in range(ngen):
		print("-- Generation %i --" % g)

		# Select the next generation individuals
		offspring = toolbox.select(pop, len(pop)) # Select the best individuals in the population

		# Clone the selected individuals
		offspring = list(toolbox.map(toolbox.clone, offspring)) #Create the offspring

		# Apply crossover on the offspring
		for child1, child2 in zip(offspring[::2], offspring[1::2]):
			if random.random() < cxpb:
				toolbox.mate(child1, child2)
				del child1.fitness.values
				del child2.fitness.values

		# Apply mutation on the offspring
		for mutant in offspring:
			# mutate an individual with probability mutpb
			if random.random() < mutpb:
				toolbox.mutate(mutant)
				del mutant.fitness.values

		# Evaluate the individuals with an invalid fitness
		invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
		fitnesses = toolbox.map(toolbox.evaluate, invalid_ind)
		for ind, fit in zip(invalid_ind, fitnesses):
			ind.fitness.values = fit

		# Replace the enitre population with the offspring
		pop[:] = offspring
		fits = [ind.fitness.values[0] for ind in pop]

		print(tools.selBest(pop, 1)[0]) # Best individual in the current generation
		print(tools.selBest(pop, 1)[0].fitness.values[0]) # Best fitness in the current generation

	# For parallel evaluation using multiprocessing
	#if paral_eval:
		#pool.close()
		#pool.join()

	res = tools.selBest(pop, 1)[0] # Best individual in normalised form
	cand = [scale[i]*v + offset[i] for i, v in enumerate(res)] # Denormalised best individual

	return res.fitness.values[0], cand


def st_sciopt(objfunc, op_meth, par_b, par_0, maxiter, scale, offset):

	try:
		from scipy import optimize as sciopt
	except ImportError:
		sciopt = None

	res = sciopt.minimize(objfunc, par_0, method=op_meth, bounds=par_b,
			options={
				#'maxfev': args.maxiter,
				'maxiter': maxiter,
				'disp': True,
			})
	print("")
	print('-----------')
	print('results',res)
	print('-----------')
	print("")
	cand = [scale[i]*v + offset[i] for i, v in enumerate(res.x)]

	return res.fun, cand 

def st_nsga2(objfunc, obj_n, par_b, par_n, scale, offset, dm_method, decisionmaker):
	
	import random
	import scoop
	from scoop import futures
	t_start=time.time()
	try:
		import deap
		from deap import algorithms, base, creator, tools
	except ImportError:
		deap = None

	assert deap is not None, 'Library for deap is not installed'

	lb = [v[0] for v in par_b] # Normalised lower bound
	ub = [v[1] for v in par_b] # Normalised upper bound

	ind_size = len(par_n) # Number of design parameters
	pop_size = 100 # Set number of individuals in population
	ngen = 20 # Total number of generation to run
	cxpb = 0.98 # Crossover probability
	#cxpb_in = 0.5 # Probability of crossover within individual
	#mutpb = 0.02 # Mutation probability
	#mutpb_in = 0.01 # Probability of mutation within individual
	paral_eval = False # To enable parallel evaluation. Only use it when the fitness function is slow!
	n_cores = 4 # Number of cores for parallel evaluation of the fitness function

	creator.create("FitnessMulti", base.Fitness, weights=(-1.0, -1.0))
	creator.create("Individual", list, fitness=creator.FitnessMulti)

	toolbox = base.Toolbox() # Attribute generator
	toolbox.register("attr_float", random.uniform, lb[0], ub[0]) # Generate a vector of uniform random numbers within the lower and upper bounds of the design variables
	toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_float, ind_size) # Structure initializer for individuals
	toolbox.register("population", tools.initRepeat, list, toolbox.individual) # Structure initializer for the population 

				# Decorator to obtain a constrained domain that is applied to the mutation and crossover
	#def checkBounds(min, max):
		#def decorator(func):
			#def wrappper(*args, **kargs):
				#offspring = func(*args, **kargs)
				#for child in offspring:
					#for i in range(len(child)):
						#if child[i] > max:
							#child[i] = max
						#elif child[i] < min:
							#child[i] = min
				#return offspring
			#return wrappper
		#return decorator

	# NOTE: For penalty function-based constraint handling see: http://deap.readthedocs.io/en/master/tutorials/advanced/constraints.html

	# Register the GA operators
	toolbox.register("evaluate", objfunc) # Set the evaluation function
	#toolbox.register("mate", tools.cxUniform, indpb=cxpb_in) # Set the crossover type
	toolbox.register("mate", tools.cxSimulatedBinaryBounded, low=lb[0], up=ub[0], eta=20.0) # Set the crossover type
	#toolbox.register("mutate", tools.mutFlipBit, indpb=mutpb_in) # Set the mutation type
	toolbox.register("mutate", tools.mutPolynomialBounded, low=lb[0], up=ub[0], eta=20.0, indpb=1.0/ind_size) # Set the mutation type
	toolbox.register("select", tools.selNSGA2) # Set the selector method

	#toolbox.decorate("mate", checkBounds(lb[0], ub[0])) # Check bounds for a constrained domain
	#toolbox.decorate("mutate", checkBounds(lb[0], ub[0])) # Check bounds for a constrained domain

	# Parallel evaluation by running the computation multicore
	if paral_eval:
		#pool = multiprocessing.Pool(processes=n_cores)
		#toolbox.register("map", pool.map) # Change the map functions everywhere to toolbox.map to make the algorithm use a multicored map
		toolbox.register("map", futures.map) # Change the map functions everywhere to toolbox.map to make the algorithm use a multicored map

	stats = tools.Statistics(lambda ind: ind.fitness.values) # Set the optimisation statistics
	stats.register("avg", np.mean, axis=0)
	stats.register("std", np.std, axis=0)
	stats.register("min", np.min, axis=0)
	stats.register("max", np.max, axis=0)

	logbook = tools.Logbook() # Logging data
	logbook.header = "gen", "evals", "std", "min", "avg", "max"

	pop = toolbox.population(n=pop_size) # Set the size of population (individuals)
	hof = tools.ParetoFront() # The Pareto front hall of fame containing all the non-dominated individuals that ever lived in the population

	# Evaluate the individuals with an invalid fitness
	invalid_ind = [ind for ind in pop if not ind.fitness.valid]
	fitnesses = toolbox.map(toolbox.evaluate, invalid_ind)
	for ind, fit in zip(invalid_ind, fitnesses):
		ind.fitness.values = fit

	# This is just to assign the crowding distance to the individuals
	# no actual selection is done
	pop = toolbox.select(pop, len(pop))

	record = stats.compile(pop)
	logbook.record(gen=0, evals=len(invalid_ind), **record)
	#print(logbook.stream)

	# Begin the generational process
	print("Starting optimisation...")
	for gen in range(ngen):
		print("-- Generation %i --" % gen)
		# Vary the population
		offspring = tools.selTournamentDCD(pop, len(pop))
		offspring = [toolbox.clone(ind) for ind in offspring]

		for ind1, ind2 in zip(offspring[::2], offspring[1::2]):
			if random.random() <= cxpb:
				toolbox.mate(ind1, ind2)

				toolbox.mutate(ind1)
				toolbox.mutate(ind2)
				del ind1.fitness.values, ind2.fitness.values

		# Evaluate the individuals with an invalid fitness
		invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
		fitnesses = toolbox.map(toolbox.evaluate, invalid_ind)
		for ind, fit in zip(invalid_ind, fitnesses):
			ind.fitness.values = fit

		# Select the next generation population
		pop = toolbox.select(pop + offspring, pop_size)
		record = stats.compile(pop)
		logbook.record(gen=gen, evals=len(invalid_ind), **record)
		#print(logbook.stream)

	# For parallel evaluation using multiprocessing
	#if paral_eval:
		#pool.close()
		#pool.join()

	pop.sort(key=lambda x: x.fitness.values)

	solutions = pop # Normalised non-dominated optimal individuals
	fitnesss = [ind.fitness.values for ind in pop] # optimal values of objective functions

	cand = []
	for ind in pop:
		cand.append([scale[i]*v + offset[i] for i, v in enumerate(ind)]) # Denormalised non-dominated optimal individuals

	cands = np.array(cand)
	front = np.array(fitnesss)

	dm = decisionmaker(cands,fitnesss) # Decision-making class instance	

	return cands, front, dm

	





