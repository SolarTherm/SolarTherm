#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SolarFuelSystem.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m', solver='dassl', nls='homotopy')
		self.res = postproc.SimResultFuel(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.assertAlmostEqual(self.perf[0], 9767106.22, 2) # fpy
		self.assertAlmostEqual(self.perf[1], 3.25, 2) # LCOF
		self.assertAlmostEqual(self.perf[2], 72.04, 2) # Capacity factor
		print(self.perf);

if __name__ == '__main__':
	unittest.main()
