
# load the necessary Python modeuls
import dakota.interfacing as di
import os
import glob

from solartherm import postproc
from solartherm import simulation
import DyMat
import numpy as np

def run():

	interface=Interface()	

	interface.init_st_model()
	
	if interface.analysis_type=='CONTINGENCY':
		interface.update_st_params_contingency()		
	else:
		interface.update_st_params()
		
	interface.run_st_model()
	interface.get_st_res()
	interface.cleanup()


class Interface:

	def __init__(self):

		self.params, self.results = di.read_parameters_file()			
		self.names=self.params.descriptors

		# electricity (lcoe), fuel (lcof), test, or contingency			
		self.analysis_type=self.params.__getitem__("analysis_type") 
		
	def init_st_model(self):
		'''
		initialise and compile the SolarTherm model 
		using the parameters that are parsed by DAKOTA
		'''
		
		fn=self.params.__getitem__("fn") #the modelica file
		self.model=os.path.splitext(os.path.split(fn)[1])[0] # model name	
		self.suffix=self.results.results_file.split(".")[-1] # case suffix			
		# initialise and compile the solartherm model
		self.sim = simulation.Simulator(fn=fn, suffix=self.suffix, fusemount=False)
		if not os.path.exists(self.model):
			print('compile model')
			self.sim.compile_model()
			self.sim.compile_sim(args=['-s'])
		print('finish compile')


	def update_st_params(self):

		self.num_res=int(self.params.__getitem__("num_res"))		
		
		var_n=[] # variable names
		var_v=[] # variable values
		print('')
		print(self.names[:-(15+2*self.num_res)]) 
		for n in self.names[:-(15+2*self.num_res)]: # the first 15 params are init_st_model related 
			#var_n.append(n.encode("UTF-8"))
			var_n.append(str(n))
			var_v.append(str(self.params.__getitem__(n)))
			print('variable   : ', n, '=', self.params.__getitem__(n))
			
		runsolstice=float(self.params.__getitem__("runsolstice"))
		if runsolstice:
			optic_folder='optic_case_%s'%self.suffix
			var_n.append('casefolder')
			var_v.append(optic_folder)
			print('casefolder = '+ optic_folder)

		self.sim.update_pars(var_n, var_v)
		self.var_n=var_n

	def update_st_params_contingency(self):

		self.num_res=int(self.params.__getitem__("num_res"))		
		num_ct_var=self.num_res-1 # number of uncertain variable
		
		var_n=[] # variable names
		var_v=[] # variable values
		print('')
		print(self.names[:-(15+2*self.num_res+2*num_ct_var)]) 
		for n in self.names[:-(15+2*self.num_res+2*num_ct_var)]: # the first 15 params are init_st_model related 
			#var_n.append(n.encode("UTF-8"))
			var_n.append(str(n))
			var_v.append(str(self.params.__getitem__(n)))
			print('variable   : ', n, '=', self.params.__getitem__(n))
				
		runsolstice=float(self.params.__getitem__("runsolstice"))
		if runsolstice:
			optic_folder='optic_case_%s'%self.suffix
			var_n.append('casefolder')
			var_v.append(optic_folder)
			print('casefolder = '+ optic_folder)


		# the (num_res-1) parameters are uncertain performance parameters 
		for i in range(1, self.num_res):
			name=self.params.__getitem__("res_%s"%(i+1))
			lb=self.params.__getitem__('lb_%s'%(i+1))
			ub=self.params.__getitem__('ub_%s'%(i+1))
			val=np.random.uniform(low=lb,high=ub,size=1)			
			var_n.append(name)
			var_v.append(str(val[0]))			
			print(name, val)

		self.sim.update_pars(var_n, var_v)
		self.var_n=var_n
		
	def run_st_model(self):
	
		start=str(self.params.__getitem__("start")) 
		stop=str(self.params.__getitem__("stop")) 
		step=str(self.params.__getitem__("step"))
		initStep=self.params.__getitem__("initStep")
		maxStep=self.params.__getitem__("maxStep") 
		integOrder=str(self.params.__getitem__("integOrder"))
		tolerance=str(self.params.__getitem__("tolerance"))
		solver=str(self.params.__getitem__("solver"))
		nls=str(self.params.__getitem__("nls"))
		lv=str(self.params.__getitem__("lv"))

		initStep = None if initStep == 'None' else str(initStep)
		maxStep = None if maxStep == 'None' else str(maxStep)

		self.sim.simulate(start=start, stop=stop, step=step, initStep=initStep, maxStep=maxStep, integOrder=integOrder, solver=solver, nls=nls, lv=lv)		

	def get_st_res(self):
	
		peaker=float(self.params.__getitem__("peaker"))
		
		try:
			res_fn=DyMat.DyMatFile(self.sim.res_fn)	
			print('Result fn is loaded, fn=', self.sim.res_fn)					
		except:			
			print('Result fn cannot be open, fn=', self.sim.res_fn)	
			
		try:	
			
			if self.analysis_type!='TEST':
				if self.analysis_type=='FUEL':
					resultclass = postproc.SimResultFuel(self.sim.res_fn)			

				else:
					resultclass = postproc.SimResultElec(self.sim.res_fn)	
					if peaker:
						perf = resultclass.calc_perf(perker=bool(peaker))
					else:	
						perf = resultclass.calc_perf()	
					summary=resultclass.report_summary(var_n=self.var_n, savedir='.', suffix=self.suffix)								
							
			solartherm_res=[]
			for i in range(self.num_res):
				sign=float(self.params.__getitem__("sign_%s"%(i+1)))
				name=self.params.__getitem__("res_%s"%(i+1))
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
			for i in range(self.num_res):	
				sign=float(self.params.__getitem__("sign_%s"%(i+1)))
				if sign>0: #minimisation
					error=99999
				else: # maxmisation
					error=0 
				solartherm_res.append(sign*error)
			print('Failed to process the results')
	
		print('')
		# Return the results to Dakota
		for i, r in enumerate(self.results.responses()):
			if r.asv.function:
				r.function = solartherm_res[i]
		self.results.write()
	
	def cleanup(self):

		os.unlink(self.sim.res_fn)
		os.unlink(self.model+'_init_%s.xml'%self.suffix)

		
