#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestReference(unittest.TestCase):
	def setUp(self):
		fn = '../examples/Reference_2.mo'
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
		self.assertTrue(abs(self.perf[0]- 399743.26)/399743.26<0.01) # epy
		self.assertTrue(abs(self.perf[1]-  158.11)/ 158.11<0.01) # LCOE
		self.assertTrue(abs(self.perf[2]- 45.63)/45.63<0.01) # Capacity factor
		os.system('rm Reference_2*')




if __name__ == '__main__':
	unittest.main()
