#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestOptEffCatrom(unittest.TestCase):
	def setUp(self):
		fn = 'TestOptEffCatrom.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step=300)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_opt_eff_interp(self):
		pass
		#self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 0.1), 0)

if __name__ == '__main__':
	unittest.main()
