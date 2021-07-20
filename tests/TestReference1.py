#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestReference(unittest.TestCase):
	def setUp(self):
		fn = '../examples/Reference_1.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		print(self.perf)
		self.assertTrue(abs(self.perf[0]- 400125.9)/400125.9<0.01) # epy
		self.assertTrue(abs(self.perf[1]- 157.96)/157.96<0.01) # LCOE
		self.assertTrue(abs(self.perf[2]- 45.67)/45.67<0.01) # Capacity factor
		os.system('rm Reference_1*')


if __name__ == '__main__':
	unittest.main()
