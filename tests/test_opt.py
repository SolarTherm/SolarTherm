#! /bin/env python
from __future__ import division
import os, platform
import pytest

@pytest.mark.skipif(platform.system()=="Windows", reason="strange behaviour with Optimica on MSYS2")
def test_optimum():
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
	assert abs(res.interpolate('u', 1)-2.48)/2.48<0.02 # slightly wider tol needed for 1.14, else 0.01 is OK.

	cleantest.clean('AO')

