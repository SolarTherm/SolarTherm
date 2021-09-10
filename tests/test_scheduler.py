#! /bin/env python

from __future__ import division
import unittest
import os

import cleantest
from solartherm import simulation
from solartherm import postproc

from math import pi

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = 'TestScheduler.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=62*86400, step=5*60)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_sched(self):
		self.assertAlmostEqual(self.res.closest('sch1.v', 0), 0)
		self.assertAlmostEqual(self.res.closest('sch1.v', 6*3600), 0)
		self.assertAlmostEqual(self.res.closest('sch1.v', 18*3600), 1)
		self.assertAlmostEqual(self.res.closest('sch1.v', 0), 0)
		self.assertAlmostEqual(self.res.closest('sch1.v', 30*3600), 2)
		self.assertAlmostEqual(self.res.closest('sch1.v', 42*3600), 3)
		self.assertAlmostEqual(self.res.closest('sch2.v', 15*24*3600), 10)
		self.assertAlmostEqual(self.res.closest('sch2.v', 45*24*3600), 20)
		cleantest.clean('TestScheduler')

if __name__ == '__main__':
	unittest.main()
	
# vim: ts=4:sw=4:noet:tw=80
