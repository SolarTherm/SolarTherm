#! /bin/env python

from __future__ import division
import pytest

import cleantest
from solartherm import simulation
from solartherm import postproc
import os

omcver = None
try:
	import subprocess as sp
	res = sp.run(['omc','--version'],stdout=sp.PIPE,stderr=sp.PIPE,check=True)
	import packages.version as pc
	omcver = pc.parse(res.stdout.strip().split(" ")[1])
except:
	pass

@pytest.mark.skipif(not omcver or omcver >= pc.parse('1.20'),reason="Doesn't work yet with OM 1.20.0")
def test_solstice_oelt():
	fn = 'TestSolsticeOELT.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop=10, step=0.1)
	res = postproc.SimResult(sim.model + '_res.mat')

	assert abs(res.interpolate('opt_eff', 0)-0.8785)/0.8785<0.01
	cleantest.clean('TestSolsticeOELT')

if __name__ == '__main__':
	test_solstice_oelt()

