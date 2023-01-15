#! /bin/env python
from __future__ import division
import os, platform
import pytest
import subprocess as sp
import packaging.version as pv

omcver = pv.parse('0')
try:
	if platform.system()!="Windows":
		res = sp.run(['omc','--version'],stdout=sp.PIPE,stderr=sp.PIPE,check=True,encoding='utf-8')
		omcver = pv.parse(res.stdout.strip().split(' ')[1])
except:
	pass

@pytest.mark.skipif(omcver <= pv.parse('1.14.2'), reason="Optimica known to fail in old OM (got %s)"%(omcver))
#@pytest.mark.skipif(platform.system()=="Windows", reason="strange behaviour with Optimica on MSYS2")
def test_optimum():
	print("DOING IT")
	from solartherm import simulation
	from solartherm import postproc
	import cleantest
	fn = 'TestOptimisation.mo'
	model = 'AO'
	sim = simulation.Simulator(fn, model=model)
	# For some reason won't compile with Modelica library
	sim.compile_model(libs=[], args=['-g=Optimica'])
	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop=1, step=0.02, solver='optimization')
	res = postproc.SimResult(sim.model + '_res.mat')

	assert abs(res.interpolate('x1', 0)-1.0)/1.0<0.01
	assert abs(res.interpolate('x2', 0)-0.0)<0.01
	assert abs(res.interpolate('u', 1)-2.48)/2.48<0.01

	cleantest.clean('AO')

if __name__=='__main__':
	test_optimum()
