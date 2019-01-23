#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

class TestExternalC(unittest.TestCase):
	def setUp(self):
		fn = 'TestExternalPyFunc.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=4, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_squaring(self):
		self.assertEqual(self.res.interpolate('y', 1), 1)
		self.assertEqual(self.res.interpolate('y', 2), 4)

if __name__ == '__main__':
	unittest.main()
