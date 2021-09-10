#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/FluidSystem.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.assertAlmostEqual(self.perf[0], 329.94, 2) # epy
		self.assertAlmostEqual(self.perf[1], 111.55, 2) # LCOE
		self.assertAlmostEqual(self.perf[2], 37.66, 2) # Capacity factor
		os.system('rm FluidSystem*')

if __name__ == '__main__':
	unittest.main()
