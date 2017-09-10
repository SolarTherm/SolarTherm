#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/TroughWagner.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		# From modified SAM version of model, see TroughWagner.mo:
		# Annual energy 371GWh
		# Capf 42.4%
		# LCOE (nominal) 13.98c/kWh
		# There is some mismatch still for which we are waiting further
		# information on the SAM implementation.
		self.assertAlmostEqual(self.perf[0], 371e3, delta=12e3) # epy
		self.assertAlmostEqual(self.perf[1], 139.8, delta=4) # LCOE
		self.assertAlmostEqual(self.perf[2], 42.4, delta=1.5) # Capacity factor

if __name__ == '__main__':
	unittest.main()
