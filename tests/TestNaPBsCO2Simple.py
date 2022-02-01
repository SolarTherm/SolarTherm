#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestNaPBsCO2Simplified(unittest.TestCase):
	def setUp(self):
		fn = '../examples/ASTRI/NaSTsCO2Simple.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		print(self.perf)
		self.assertTrue(abs(self.perf[0]- 472629.83)/472629.83<0.1) # epy
		self.assertTrue(abs(self.perf[1]- 72.25)/72.25<0.1) # LCOE
		self.assertTrue(abs(self.perf[2]- 53.95)/53.95<0.1) # Capacity factor
		os.system('rm NaSTsCO2*')
    		

if __name__ == '__main__':
	unittest.main()
