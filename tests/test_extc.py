#! /bin/env python

from __future__ import division
import unittest

import cleantest
from solartherm import simulation
from solartherm import postproc
import os

class TestExternalC(unittest.TestCase):
	def setUp(self):
		fn = 'TestExternalC.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=5, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_squaring(self):
		self.assertEqual(self.res.interpolate('y', 1), 1)
		self.assertEqual(self.res.interpolate('y', 2), 4)
		self.assertEqual(self.res.interpolate('y', 3), 9)
		self.assertEqual(self.res.interpolate('y', 4), 16)
		cleantest.clean('TestExternalC')

if __name__ == '__main__':
	unittest.main()
