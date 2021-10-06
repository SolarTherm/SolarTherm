#! /bin/env python

from __future__ import division
import pytest

import cleantest
from solartherm import simulation
from solartherm import postproc

import os

@pytest.mark.skip(reason="Broken at the moment!")
def test_system():
	fn = '../examples/SimpleSystemOptimalDispatch.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
	res = postproc.SimResultElec(sim.res_fn)
	perf = res.calc_perf(peaker=True)

	# Note these are set to the values for what is thought to be a working
	# version.  They are not validated against anything or independently
	# calculated.
	print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
	print(perf);
	assert abs(perf[0]- 300.757)/300.757<0.01 # epy
	assert abs(perf[1]- 38.798)/38.798<0.01 # LCOE peaker
	assert abs(perf[2]- 100.09)/100.09<0.01 # Capacity factor
	cleantest.clean('SimpleSystemOptimalDispatch')git s

