#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import os

class TestWeatherFileChecker(unittest.TestCase):
	def setUp(self):
		if os.path.isfile('resources/tests/weatherfile2.motab'):
			os.remove('resources/tests/weatherfile2.motab')

		fn = 'TestWeatherFileChecker.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=1, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_checker(self):
		self.assertTrue(self.res.closest('fn1_correct', 0))
		self.assertTrue(self.res.closest('fn2_correct', 0))
		self.assertTrue(os.path.isfile('resources/tests/weatherfile2.motab'))

if __name__ == '__main__':
	unittest.main()
