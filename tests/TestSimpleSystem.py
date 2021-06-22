#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import os

class TestSimpleSystem(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SimpleSystem.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m', solver='dassl', nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_simple_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.

		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(self.perf);
		self.assertTrue(abs(self.perf[0]- 352.558)/352.558<0.01) # epy
		self.assertTrue(abs(self.perf[1]- 96.490)/96.490<0.01) # LCOE
		self.assertTrue(abs(self.perf[2]- 40.246)/40.246<0.01) # Capacity factor
		os.system('rm SimpleSystem*')


if __name__ == '__main__':
	unittest.main()





