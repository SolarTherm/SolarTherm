#! /bin/env python

from __future__ import division
import cleantest
import pytest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

def test_ref2solstice():
	fn = '../examples/Reference_2_solstice.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])
	sim.update_pars(['n_row_oelt', 'n_col_oelt'],['3', '3']) # reduce oelt resolution
	sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
	res = postproc.SimResultElec(sim.res_fn)
	perf = res.calc_perf()

	# Note these are set to the values for what is thought to be a working
	# version.  They are not validated against anything or independently
	# calculated.

	assert abs(perf[0]- 393933.791)/393933.791 < 0.1 # epy
	assert abs(perf[1]- 160.352)/160.352 < 0.1 # LCOE
	assert abs(perf[2]- 44.969)/44.969 < 0.1 # Capacity factor
	cleantest.clean('Reference_2_solstice')

# vim: ts=4:sw=4:noet:tw=80
