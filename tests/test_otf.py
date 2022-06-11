import pytest
import subprocess as sp
import shutil, platform, os
from pathlib import Path
import DyMat
import sys

import cleantest
from solartherm import simulation
from solartherm import postproc

def append_path(env,var,add):
	val = (env[var].split(os.pathsep) if var in env else []) + [str(add)]
	env[var] = os.pathsep.join(val)

def run_ctest(name):
	"""
	This simply runs the C-langage tests in testOTFsurrogate.c.
	Which is checking the functionalities of the surrogate on the fly.
	"""
	exe = './testOTFsurrogate'
	env = None
	if platform.system()=="Linux":
		env = os.environ.copy()
		append_path(env,'LD_LIBRARY_PATH',Path('../src/modelica'))
	proc = sp.run([exe,str(name)],env=env)#stdout=sp.PIPE,stderr=sp.PIPE,env=env)
	assert proc.returncode == 0

def test_loadPredictExistingSurrogate():
	"""
	Run the modelica test of LoadPredictExistingSurrogate.
	"""
	fn = './TestLoadPredictExistingSurrogate.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop='1', step='1', solver='dassl', nls='homotopy')

	res = DyMat.DyMatFile('TestLoadPredictExistingSurrogate_res.mat')
	deviation_eta_gross_Kriging = res.data('deviation_eta_gross_Kriging')[-1]
	deviation_eta_Q_Kriging = res.data('deviation_eta_Q_Kriging')[-1]
	deviation_eta_gross_ANN = res.data('deviation_eta_gross_ANN')[-1]
	deviation_eta_Q_ANN = res.data('deviation_eta_Q_ANN')[-1]

	assert abs(deviation_eta_gross_Kriging - res.data('deviation_eta_gross_Kriging')[-1]) < 0.01
	assert abs(deviation_eta_Q_Kriging - res.data('deviation_eta_Q_Kriging')[-1]) < 0.01
	assert abs(deviation_eta_gross_ANN - res.data('deviation_eta_gross_ANN')[-1]) < 0.01
	assert abs(deviation_eta_Q_ANN - res.data('deviation_eta_Q_ANN')[-1]) < 0.01
	
	cleantest.clean('TestLoadPredictExistingSurrogate')

def test_initNRELPB():
	if os.path.exists("../SolarTherm/Data/SurrogateModels/PowerBlock/configurations/configNREL3000.txt"):
		os.remove("../SolarTherm/Data/SurrogateModels/PowerBlock/configurations/configNREL3000.txt")
	run_ctest('initNRELPB')

def test_runNRELPBOffDesign():
	try:
		shutil.rmtree("../SolarTherm/Data/SurrogateModels/PowerBlock/training_data/configNREL3000")
	except:
		pass
	
	run_ctest('runNRELPBOffDesign')

	#Removing files generated when testing run NREL PB
	os.remove("../SolarTherm/Data/SurrogateModels/PowerBlock/configurations/configNREL3000.txt")
	shutil.rmtree("../SolarTherm/Data/SurrogateModels/PowerBlock/training_data/configNREL3000")


# vim: ts=4:sw=4:noet:tw=80
