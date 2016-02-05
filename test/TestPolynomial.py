#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestPolynomial(unittest.TestCase):
	def setUp(self):
		fn = 'TestPolynomial.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=10, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_poly_calc(self):
		self.assertAlmostEqual(self.res.get_interp('p1.y', 1), 1)
		self.assertAlmostEqual(self.res.get_interp('p2.y', 1), 1)
		self.assertAlmostEqual(self.res.get_interp('p3.y', 1), 6)
		self.assertAlmostEqual(self.res.get_interp('p4.y', 1), 76)

if __name__ == '__main__':
	unittest.main()
