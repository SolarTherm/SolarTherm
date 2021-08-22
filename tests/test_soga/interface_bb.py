#!/usr/bin/env python

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
num_perf=int(params.__getitem__("num_perf")) # number of the performance results 
model=os.path.splitext(os.path.split(fn)[1])[0] # model name
start=str(params.__getitem__("start")) 
stop=str(params.__getitem__("stop")) 
step=str(params.__getitem__("step"))
initStep=params.__getitem__("initStep")
maxStep=params.__getitem__("maxStep") 
integOrder=str(params.__getitem__("integOrder"))
solver=str(params.__getitem__("solver"))
nls=str(params.__getitem__("nls"))
lv=str(params.__getitem__("lv"))

runsolstice=params.__getitem__("runsolstice")
peaker=params.__getitem__("peaker")


initStep = None if initStep == 'None' else str(initStep)
maxStep = None if maxStep == 'None' else str(maxStep)

var_n=[] # variable names
var_v=[] # variable values

print('')

print(names[:-(14+2*num_perf)])
for n in names[:-(14+2*num_perf)]:
	#var_n.append(n.encode("UTF-8"))
	var_n.append(str(n))
	var_v.append(str(params.__getitem__(n)))
	print('variable   : ', n, '=', params.__getitem__(n))

# case suffix
suffix=results.results_file.split(".")[-1]


if runsolstice=='True':
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
#sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
#sim.simulate(start=0, stop='1y', step='1h',initStep='60s', maxStep='60s', solver='dassl', nls='newton')
sim.simulate(start=start, stop=stop, step=step, initStep=initStep, maxStep=maxStep, integOrder=integOrder, solver=solver, nls=nls, lv=lv)

try:
	if system=='TEST':
		import DyMat
		res=DyMat.DyMatFile(sim.res_fn)
	else:
		if system=='FUEL':
			resultclass = postproc.SimResultFuel(sim.res_fn)
		else:
			resultclass = postproc.SimResultElec(sim.res_fn)

		if peaker=='True':
			perf = resultclass.calc_perf(peaker=True)
		else:
			perf = resultclass.calc_perf()


	solartherm_res=[]

	for i in range(num_perf):
		sign=float(params.__getitem__("sign%s"%i))

		if system=='TEST':
			name=params.__getitem__("index%s"%i)
			solartherm_res.append(sign*res.data(name)[0])
			print('objective %s: '%i, name, sign*res.data(name)[0])
		else:
			idx=int(params.__getitem__("index%s"%i))
			solartherm_res.append(sign*perf[idx])
			print('objective %s: '%i, resultclass.perf_n[idx], sign*perf[idx])
except:
	solartherm_res=[]
	for i in range(num_perf):	
		sign=float(params.__getitem__("sign%s"%i))
		if sign>0: #minimisation
			error=99999
		else: # maxmisation
			error=0 

		idx=int(params.__getitem__("index%s"%i))
		solartherm_res.append(sign*error)
	print('Simulation Failed')


print('')

# Return the results to Dakota
for i, r in enumerate(results.responses()):
    if r.asv.function:
        r.function = solartherm_res[i]
results.write()

map(os.unlink, glob.glob(sim.res_fn))
#map(os.unlink, glob.glob(model+'_init_*.xml'))

