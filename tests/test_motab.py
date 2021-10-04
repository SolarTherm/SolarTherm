import pytest
import subprocess as sp
import shutil, platform, os
from pathlib import Path
import DyMat

import cleantest
from solartherm import simulation
from solartherm import postproc

def test_ctest():
	"""
	This simply runs the C-langage tests in testmotab.c, which is checking out little routines for loading
	a .motab file in C.
	"""
	exe = './testmotab'
	env = None
	if platform.system()=="Linux":
		env = os.environ.copy()
		env['LD_LIBRARY_PATH']='../src/modelica'
	proc = sp.run([exe],env=env)#stdout=sp.PIPE,stderr=sp.PIPE,env=env)
	assert(proc.returncode==0)

def test_modelica():
	"""
	Run the modelica test of STMotab.
	"""
	fn = './TestSTMotab.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop='1y', step='5m', solver='dassl', nls='homotopy')

	res = DyMat.DyMatFile('TestSTMotab_res.mat')
	assert res.data("t1")[0] == 31500000.
	assert res.data("dnival")[0] == 976.
	assert res.data("dnicol")[0] == 2.
	
	cleantest.clean('TestSTMotab')

# vim: ts=4:sw=4:noet:tw=80
