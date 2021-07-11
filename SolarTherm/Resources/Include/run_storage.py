import os
import numpy as np

from solartherm import postproc
from solartherm import simulation
import DyMat

def get_effectiveness(inputs):
	'''
	inputs is a dictionary that contains the names and values of the inputs parameters
	inputs must contain the following:
		modelicapath
		casedir (to save the motab output)

	'''
	modelicapath=inputs['modelicapath']
	mofn=modelicapath+'/EffectivenessTrainingData.mo'
	model='EffectivenessTrainingData'

	var_n=[]
	var_v=[]
	casename=''
	inputs_items=inputs.items()
	inputs_sorted=sorted(inputs_items)

	for index, tuples in enumerate(inputs_sorted):
		k=tuples[0]
		v=tuples[1]
		if k !='modelicapath' and k!='casedir':
			var_n.append(k)
			var_v.append(str(v))
			print('setting parameter %s = %s'%(k, v))
			casename+=(k+'%.2f_'%v)
	casedir=inputs['casedir']+'/'+casename

	if not os.path.exists(casedir):
		os.makedirs(casedir)

	motabfile=os.path.abspath(casedir)+'/effectiveness.motab'

	wd=os.getcwd()
	os.chdir(casedir)

	if os.path.exists(motabfile):
		print('')
		print('Load exsiting STLT') # storage lookup table
		print('')

	else:
		sim = simulation.Simulator(fn=mofn, fusemount=False)
		#if not os.path.exists(model):
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.update_pars(var_n, var_v)	
		sim.simulate(start='0', stop='518400', maxStep=60, nls='homotopy', solver='dassl')
		res=DyMat.DyMatFile(sim.res_fn)

		t_last=518400-3600*24 # time at the start of the last day	

		L=res.data('L') # level of the storage
		e_bot=res.data('e_bot') # effectiveness of charging states
		e_top=res.data('e_top') # effectiveness of discharging states
		t_stop_charge=res.data('t_stop_charge')[-1] 
		t_stop_discharge=res.data('t_stop_discharge')[-1] 
		
		t=res.abscissa('L',  valuesOnly=True)
		

		level_chg=np.array([])
		level_dischg=np.array([])
		eps_chg=np.array([])
		eps_dischg=np.array([])
		for i in range(len(t)):
			if t[i]>t_last and t[i]<=t_stop_charge:
				level_chg=np.append(level_chg, np.around(L[i], decimals=5))
				eps_chg=np.append(eps_chg, e_bot[i])
			if t[i]>t_stop_charge and t[i]<=t_stop_discharge:
				level_dischg=np.append(level_dischg, np.around(L[i], decimals=5))
				eps_dischg=np.append(eps_dischg, e_top[i])


		# sort 'level' in an increasing order

		level_dischg, idx = np.unique(level_dischg, return_index=True)
		eps_dischg=eps_dischg[idx]
		idx_sort=np.argsort(level_dischg)
		level_dischg=level_dischg[idx_sort]
		eps_dischg=eps_dischg[idx_sort]

		level_chg, idx = np.unique(level_chg, return_index=True)
		eps_chg=eps_chg[idx]

		C_storage=res.data('C_storage')[-1]

		f=open(motabfile, 'w')
		f.write('#1\n')
		f.write('#Comments\n')
		f.write('#METALABELS,C_storage\n')
		f.write('##METAUNITS,usd\n')
		f.write('#METADATA,%s\n'%(C_storage))

		f.write('float table_charging(%s,2) #Level(-), effectiveness(-)\n'%len(eps_chg))
		for i in range(len(eps_chg)):
			f.write("%.5f %.5f"%(level_chg[i], eps_chg[i]))
			f.write("\n")
		f.write("\n")
		f.write('float table_discharging(%s,2) #Level(-), effectiveness(-)\n'%len(eps_dischg))
		for i in range(len(eps_dischg)):
			f.write("%.5f %.5f"%(level_dischg[i], eps_dischg[i]))
			f.write("\n")

		f.close()

		os.system('rm %s'%model)
		os.system('rm %s_*'%model)
		os.system('rm %s.c'%model)
		os.system('rm %s.o'%model)
		os.system('rm %s.makefile'%model)
	os.chdir(wd)
	return motabfile

if __name__=='__main__':
	import os
	p=os.path.abspath('../../Models/Storage')
	print('path',p)
	inputs={'modelicapath':p, 'casedir':'.', 't_storage':9}
	get_effectiveness(inputs)
	
	
