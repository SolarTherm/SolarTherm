#!/usr/bin/env python
##
# The Python wrapper to call DAKOTA to perform:
# I.   Parametric study, e.g. uniform, LHS etc
# II.  Uncertainty study, e.g. Monte-Carlo, LHS etc
# III. Optimisation, e.g. 
#     	(1) gradient-based 
#     	(2) non-gradient-based
#     	(3) derivative-free
#     	(4) surrogate-based
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
# develop it for the uncertainty study first
# the next is to generalise it to parametric study and optimisation
# more complex parallelism is also to be developed (tested)


import os

def gen_dakota_in(mode, sample_type, num_sample, dist_type, var_num, var_names, var_vals, mofn, savedir):
	'''
	Generate dakota input file: sample.in

	Arguments:
	* `mode` (str): 'uncertainty' or 'parametric' or 'optimisation
	* `sample_type` (str): 'lhs' (i.e. Latin hyper-cube sample) 
						or 'random'(i.e. MC sample)	 
	* `num_sample` (int): number of samples
	* `dist_type` (str): e.g. 'uniform' or 'normal' or 'beta' etc	 
	* `var_num` (int): number of variables
	* `var_names` (list of str): names of the variables
	* `var_vals` (list of float): value range of the variables, e.g. [[lb1,ub1],[lb2,ub2],[lb3,ub3]] for the three variables
	* `mofn` (str): the absolute directory of the modelica file
	* `savedir` (str): directory to save the sample.in file	

	'''

	sample='''
# Dakota Input File: sample.in
# Usage:
#    dakota -i sample.in -o sample.out > sample.stdout
# or if run in multi-level parallelism:
#    mpirun dakota -i sample.in -o sample.out > sample.stdout

environment
    tabular_data
    tabular_data_file = "sample.dat"

model
    single

interface
    fork
    analysis_drivers = "%s/interface_bb.py"
    parameters_file = "params.in"
    results_file = "results.out"
	file_tag 
	#file_save 

responses
    response_functions = 1
    no_gradients
    no_hessians

variables
	discrete_state_set
		string 1
		set_values "%s"
		descriptors "fn"

'''%(savedir,mofn)

	# variables
	if mode=='uncertainty':
		# TODO multiple different distributions
		# suggestion: class of distribution, input, output, spreadsheet
		# sample+=distribution.dakotainput  
		# TODO class of DAKOTA, optimisation, parametric
		sample+='    %s_uncertain=%s\n'%(dist_type,var_num)
		if dist_type=='uniform':
			lb=''
			ub=''
			descriptor=''
			for i in range(var_num):
				lb+=' %s'%var_vals[i][0]
				ub+=' %s'%var_vals[i][1]
				descriptor+=' "%s"'%var_names[i]							
			sample+='        lower_bounds'+lb+'\n'
			sample+='        upper_bounds'+ub+'\n'
			sample+='        descriptors'+descriptor+'\n'

	# mothod
	sample+='\nmethod\n'
	if mode=='uncertainty':
		sample+='    sampling\n'
		sample+='        sample_type %s\n'%sample_type		
		sample+='        samples = %s\n'%num_sample


	if not os.path.exists(savedir):
		os.makedirs(savedir)
	with open(savedir+'/sample.in', 'w') as f:
		f.write(sample)


def gen_interface_bb(savedir):
	'''
	This function generate the interface_bb.py script 
	which will be excuted by DAKOTA

	* `savedir` (str): directory to save the interface_bb.py file	
	'''

	bb='''#!/usr/bin/env python

# Dakota will execute this script
# The command line arguments will be extracted by dakota.interfacing automatically.

# load the necessary Python modeuls
import dakota.interfacing as di
import os

# Parse Dakota parameters file
params, results = di.read_parameters_file()

# obtain the modelica file name
# variable names and values
# index of the case (suffix for output)
names=params.descriptors
fn=params.__getitem__("fn") #the modelica file
model=os.path.splitext(os.path.split(fn)[1])[0] # model name

var_n=[] # variable names
var_v=[] # variable values
for n in names[:-1]:
	var_n.append(n.encode("UTF-8"))
	var_v.append(str(params.__getitem__(n)))
# case suffix
suffix=results.results_file.split(".")[-1]

# run solartherm
from solartherm import postproc
from solartherm import simulation
sim = simulation.Simulator(fn=fn, suffix=suffix, fusemount=False)
if not os.path.exists(model):
	sim.compile_model()
	sim.compile_sim(args=['-s'])

sim.update_pars(var_n, var_v)
sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')

resultclass = postproc.SimResultElec(sim.res_fn)
perf = resultclass.calc_perf()

epy=perf[0]
lcoe=perf[1]
capf=perf[2]
solartherm_res=[lcoe, capf, epy]
print solartherm_res	
# Return the results to Dakota
for i, r in enumerate(results.responses()):
    if r.asv.function:
        print i
        r.function = solartherm_res[i]

results.write()
	'''
	if not os.path.exists(savedir):
		os.makedirs(savedir)
	with open(savedir+'/interface_bb.py', 'w') as f:
		f.write(bb)

if __name__=='__main__':
	'''
	mode='uncertainty'
	sample_type='lhs'
	num_sample=20
	dist_type='uniform'
	var_num=3
	var_names=["rec_fr","eff_blk","he_av_design"]
	var_vals=[[0.01,0.09],[0.25,0.42],[0.985,0.995]]
	mofn="/home/yewang/solartherm-master/examples/Reference_2.mo"
	savedir='/media/yewang/Data/svn_gen3p3/system-modelling/research/sensitivity-analysis-DAKOTA/test'
	gen_dakota_in(mode, sample_type, num_sample, dist_type, var_num, var_names, var_vals, mofn, savedir)
	'''



