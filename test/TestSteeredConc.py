#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestSteeredConc(unittest.TestCase):
	def setUp(self):
		fn = 'TestSteeredConc.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=200, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_steering(self):
		self.assertAlmostEqual(self.res.get_interp('conc.R_foc[1]', 0), 0)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 1), 0)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 11), 0.1)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 51), 0.499)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 100), 0.499)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 120), 0.299)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 130), 0.201)
		self.assertAlmostEqual(self.res.get_interp('conc.actual', 200), 0.201)

if __name__ == '__main__':
	unittest.main()
