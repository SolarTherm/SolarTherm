#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = 'TestPanel.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=200, step=0.4, solver='dassl')

	def test_sched(self):
		def getval(n):
			return self.res.interpolate(n,1)

if __name__ == '__main__':
	unittest.main()
