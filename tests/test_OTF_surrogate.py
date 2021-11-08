import pytest
import subprocess as sp
import shutil, platform, os
from pathlib import Path
import DyMat

import cleantest
from solartherm import simulation
from solartherm import postproc

def run_ctest(name):
	"""
	This simply runs the C-langage tests in testOTFsurrogate.c.
	Which is checking the functionalities of the surrogate on the fly.
	"""
	exe = './testOTFsurrogate'
	env = None
	if platform.system()=="Linux":
		env = os.environ.copy()
		env['LD_LIBRARY_PATH']='../src/modelica'
	proc = sp.run([exe,str(name)],env=env)#stdout=sp.PIPE,stderr=sp.PIPE,env=env)
	assert proc.returncode == 0

def test_initNRELPB():
	run_ctest('initNRELPB')

def test_loadExistingKriging():
	run_ctest('loadExistingKriging')

'''

def test_daggett():
	run_ctest('daggett')

def test_wrap():
	run_ctest('wrap')

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
'''
# vim: ts=4:sw=4:noet:tw=80
