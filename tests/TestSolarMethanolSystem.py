#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SolarMethanolSystem.mo'
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
		self.assertTrue(abs(self.perf[0]- 21077831.1)/21077831.1<0.01) # fpy
		self.assertTrue(abs(self.perf[1]- 1.52)/1.52<0.01) # LCOF
		self.assertTrue(abs(self.perf[2]- 72.46)/72.46<0.01) # Capacity factor
		os.system('rm SolarMethanolSystem*')

if __name__ == '__main__':
	unittest.main()
