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

def gen_dakota_in(mode, sample_type, num_sample, dist_type, var_num, var_names, var_vals, savedir):
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
	* `savedir` (str): directory to save the sample.in file	

	'''
	sample='\n' # the input sample.in of dakota
	sample+='# Dakota Input File: sample.in\n# Usage:\n#    dakota -i sample.in -o sample.out > sample.stdout\n# or if run in multi-level parallelism:\n#    mpirun dakota -i sample.in -o sample.out > sample.stdout\n\n'

	# Six Sections 

	# (1) environment
	sample+='\nenvironment\n'
	sample+='    tabular_data\n'	
	sample+='    tabular_data_file = "sample.dat"\n'

	# (2) mothod
	sample+='\nmethod\n'
	if mode=='uncertainty':
		sample+='    sampling\n'
		sample+='        sample_type %s\n'%sample_type		
		sample+='        samples = %s\n'%num_sample

	# (3) model
	sample+='\nmodel\n'
	sample+='    single\n'

	# (4) variables
	sample+='\nvariables\n'
	if mode=='uncertainty':
		sample+='    %s_uncertain=%s\n'%(dist_type,var_num)
		if dist_type=='uniform':
			lb=''
			ub=''
			descriptor=''
			for i in range(var_num):
				lb+=' %s'%var_vals[i][0]
				ub+=' %s'%var_vals[i][1]
				descriptor+=' "%s"'%var_names[i]							
			sample+='    lower_bounds'+lb+'\n'
			sample+='    upper_bounds'+ub+'\n'
			sample+='    descriptors'+descriptor+'\n'

	# (5) interface
	sample+='\ninterface\n'
	sample+='    fork\n'
	sample+='    analysis_drivers = "system_bb.py"\n'
	sample+='    parameters_file = "params.in"\n'
	sample+='    results_file = "results.out"\n'


	# (6) responses
	sample+='\nresponses\n'
	sample+='    response_functions = 1\n'
	sample+='    no_gradients\n'
	sample+='    no_hessians\n'

	if not os.path.exists(savedir):
		os.makedirs(savedir)
	with open(savedir+'/sample.in', 'w') as f:
		f.write(sample)

def gen_system_bb(var_names, savedir):
	'''
	Generate system_bb.py

	Arguments:
	* `var_names` (list of str): names of the variables
	* `savedir` (str): directory to save the sample.in file	
	'''

	system='#!/usr/bin/env python\n\n'
	system+='# Dakota will execute this script\n'
	system+='# The command line arguments will be extracted by dakota.interfacing automatically.\n'

	system+='\n# load the necessary Python modeuls\n' 		
	system+='import dakota.interfacing as di\n'

	system+='\n# Parse Dakota parameters file\n'
	system+='params, results = di.read_parameters_file()\n'
	system+='\n# Convert and send to application\n'
	system+='\n# set up the data structures\n# for this simple example, put all the\n# variables into a single hardwired array\n# The asv has to be mapped back into an integer\n'

	var_num=len(var_names)
	pm=''
	for i in range(var_num):
		if i==0:
			pm+='params["%s"]'%var_names[i]
		else:
			pm+=',\n                    params["%s"]'%var_names[i]
	system+='continuous_vars =  ['+pm+']\n'
	system+='active_set_vector = 1\n'
	system+='\n# set a dictionary for passing to via Python kwargs\n'
	system+='solartherm_params = {}\n'
	system+='solartherm_params["cv"] = continuous_vars\n'
	system+='solartherm_params["asv"] = [active_set_vector]\n'	
	system+='solartherm_params["functions"] = 1\n'
	# TODO	
	# use st_simulate directly, instead of another run_solartherm script??
	system+='\n\n# execute the analysis as a separate Python module\n'
	system+='from run_solartherm import run_solartherm\n'
	system+='solartherm_results = run_solartherm(**solartherm_params)\n'
	system+='\n\n# Return the results to Dakota\n'
	system+='for i, r in enumerate(results.responses()):\n'
	system+='    if r.asv.function:\n'
	system+='        r.function = solartherm_results["fns"][i]\n\n'
	system+='results.write()'


	if not os.path.exists(savedir):
		os.makedirs(savedir)
	with open(savedir+'/system_bb.py', 'w') as f:
		f.write(system)

def gen_run(var_names, modir, mofn, savedir):
	'''
	Generate system_bb.py

	Arguments:
	* `var_names` (list of str): names of the variables
	* `modir` (str): path of the modelica file 
	* `mofn` (str): name of the modelica file (.mo)
	* `savedir` (str): directory to save the sample.in file	
	'''

	run='import DyMat\nimport os\nimport numpy as N\nfrom solartherm import postproc\nimport datetime,time\n\n'
	run+='def run_solartherm(**kwargs):\n\n'
	run+='    names=%s\n'%var_names
	run+='    mofile="%s"\n'%modir
	run+='    fn_mo="%s"\n'%mofn
	run+='    num_fns = kwargs["functions"]\n'
	run+='    x = kwargs["cv"]\n'
	run+='    ASV = kwargs["asv"]\n'
	run+='    retval = dict([])\n'
	run+='    cwd=os.getcwd()\n'

	run+='    suffix = ""\n'
	run+='    snum = 0\n'
	run+='    while 1:\n'
	run+='        dt = datetime.datetime.now()\n'
	run+='        ds = dt.strftime("%a-%H-%M")\n'
	run+='        casefolder = os.path.join(os.getcwd(),"case-%s%s"%(ds,suffix))\n'
	run+='        if os.path.exists(casefolder):\n'
	run+='            snum+=1\n'
	run+='            suffix = "-%d"%(snum,)\n'
	run+='            if snum > 200:\n'
	run+='                raise RuntimeError("Some problem with creating casefolder")\n'
	run+='        else:\n'
	run+='            # good, we have a new case dir\n'
	run+='            os.makedirs(casefolder)\n'
	run+='            break\n'
	run+='    resfile=casefolder+"/%s_res_0.mat"%fn_mo\n'


	run+='    os.system("cp %s %s"%(mofile, casefolder))\n'
	run+='    os.chdir(casefolder)\n'

	run+='    cmd="st_simulate --np 0 %s.mo"%fn_mo\n'
	run+='    for i,n in enumerate(names):\n'
	run+='        cmd+=" %s=%s"%(n,x[i])\n'

	run+='    os.system(cmd)\n'
	run+='    os.system("rm *.c")\n'
	run+='    os.system("rm *.h")\n'
	run+='    os.system("rm *.o")\n'
	run+='    os.system("rm *.makefile")\n'
	run+='    os.system("rm *.xml")\n'
	run+='    os.system("rm *.json")\n'
	run+='    os.system("rm *.log")\n'

	run+='    os.chdir(cwd)\n'
    
	run+='    res = postproc.SimResultElec(resfile)\n' 
	run+='    perf=res.calc_perf()\n'
	run+='    lcoe=perf[1]\n'

	run+='    f=[float(lcoe)]\n'
	run+='    retval["fns"] = f\n'
	run+='    return(retval)\n'  

	if not os.path.exists(savedir):
		os.makedirs(savedir)
	with open(savedir+'/run_solartherm.py', 'w') as f:
		f.write(run)

if __name__=='__main__':
	mode='uncertainty'
	sample_type='lhs'
	num_sample=200
	dist_type='uniform'
	var_num=3
	var_names=["rec_fr","eff_blk","he_av_design"]
	var_vals=[[1,2],[3,4],[5,6]]
	savedir='.'
	gen_dakota_in(mode, sample_type, num_sample, dist_type, var_num, var_names, var_vals, savedir)
	gen_system_bb(var_names, savedir)
	modir="~/solartherm-master/examples/Reference_2.mo"
	mofn="Reference_2"
	gen_run(var_names, modir, mofn, savedir)

