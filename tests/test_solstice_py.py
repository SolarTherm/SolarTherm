#! /bin/env python

from __future__ import division
import pytest

import cleantest
from solartherm import simulation
from solartherm import postproc
import os

@pytest.mark.skip(reason="Some issue with SolsticePy")
def test_st_solstice():
	fn = 'TestSolsticePyFunc.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop=10, step=0.1)
	res = postproc.SimResult(sim.model + '_res.mat')
	
	assert abs(res.interpolate('nu', 0)-0.8834)/0.8834<0.01
	cleantest.clean('TestSolsticePyFunc')

