#! /bin/env python

from __future__ import division
import pytest

import cleantest
from solartherm import simulation
from solartherm import postproc

#@pytest.mark.dependency(depends=['solstice'])
@simulation.in_dir_of(__file__)
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

