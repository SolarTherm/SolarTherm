#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import os

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SimpleSystemOptimalDispatch.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf(peaker=True)

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(self.perf);
		self.assertTrue(abs(self.perf[0]- 300.757)/300.757<0.01) # epy
		self.assertTrue(abs(self.perf[1]- 38.798)/38.798<0.01) # LCOE peaker
		self.assertTrue(abs(self.perf[2]- 100.09)/100.09<0.01) # Capacity factor
		os.system('rm SimpleSystemOptimalDispatch*')


if __name__ == '__main__':
	unittest.main()

